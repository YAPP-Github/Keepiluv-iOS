//
//  AuthInterceptor.swift
//  DomainAuth
//
//  Created by Jiyong on 2/9/26.
//

import CoreNetworkInterface
import DomainAuthInterface
import Foundation

/// 인증 헤더 추가 및 401 에러 시 토큰 자동 갱신을 담당하는 Interceptor입니다.
///
/// ## 기능
/// - `adapt`: requiresAuth가 true인 요청에 Authorization 헤더 추가
/// - `retry`: 401 에러 시 토큰 갱신 후 재시도 (최대 1회)
///
/// ## 무한 재귀 방지
/// - `/auth/refresh` 경로는 재시도하지 않음
/// - 최대 시도 횟수 제한 (원본 1회 + 재시도 1회)
///
/// ## 사용 예시
/// ```swift
/// let authInterceptor = AuthInterceptor(
///     tokenManager: TokenManager.shared,
///     refreshToken: { try await authClient.refreshToken() }
/// )
/// let provider = NetworkProvider(interceptors: [authInterceptor])
/// ```
public final class AuthInterceptor: NetworkInterceptor, @unchecked Sendable {
    private let tokenManager: TokenManager
    private let refreshToken: @Sendable () async throws -> Token
    private let refreshState = RefreshState()

    public init(
        tokenManager: TokenManager,
        refreshToken: @escaping @Sendable () async throws -> Token
    ) {
        self.tokenManager = tokenManager
        self.refreshToken = refreshToken
    }

    // MARK: - NetworkInterceptor

    public func didCreateTask(_ task: URLSessionTask) {}
    public func didReceiveData(_ task: URLSessionDataTask, data: Data) {}
    public func didCompleteTask(_ task: URLSessionTask, error: Error?) {}

    public func adapt(_ context: RequestContext) async throws -> RequestContext {
        guard context.endpoint.requiresAuth else {
            return context
        }

        guard let accessToken = await tokenManager.accessToken else {
            return context
        }

        var newContext = context
        newContext.request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        return newContext
    }

    public func retry(
        _ context: RequestContext,
        dueTo error: Error,
        attemptCount: Int
    ) async -> RetryDecision {
        guard attemptCount == 1 else {
            return .doNotRetry
        }

        guard let networkError = error as? NetworkError,
              networkError == .authorizationError else {
            return .doNotRetry
        }

        if context.request.url?.path.contains("/auth/refresh") == true {
            return .doNotRetry
        }

        do {
            let newToken = try await performTokenRefresh()

            var newRequest = context.request
            newRequest.setValue("Bearer \(newToken.accessToken)", forHTTPHeaderField: "Authorization")
            return .retry(newRequest)
        } catch {
            return .doNotRetry
        }
    }

    // MARK: - Private

    private func performTokenRefresh() async throws -> Token {
        try await refreshState.refresh(using: refreshToken)
    }
}

// MARK: - RefreshState

private actor RefreshState {
    private var refreshTask: Task<Token, Error>?

    func refresh(using refreshToken: @escaping @Sendable () async throws -> Token) async throws -> Token {
        // 이미 진행 중인 갱신 작업이 있으면 그 결과를 대기
        if let existingTask = refreshTask {
            return try await existingTask.value
        }

        // 새로운 갱신 작업 시작
        let task = Task {
            try await refreshToken()
        }

        refreshTask = task

        do {
            let token = try await task.value
            refreshTask = nil
            return token
        } catch {
            refreshTask = nil
            throw error
        }
    }
}
