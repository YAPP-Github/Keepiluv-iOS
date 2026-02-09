//
//  NetworkInterceptor.swift
//  CoreNetworkInterface
//
//  Created by Jiyong
//

import Foundation

/// 네트워크 요청의 생명주기를 intercept하여 로깅, 모니터링, 인증 등의 작업을 수행하는 프로토콜
public protocol NetworkInterceptor: Sendable {

    // MARK: - 관찰 메서드 (로깅/모니터링)

    /// URLSessionTask가 생성될 때 호출됩니다.
    /// - Parameter task: 생성된 URLSessionTask
    ///
    /// ## 사용 예시
    /// ```swift
    /// interceptor.didCreateTask(task)
    /// ```
    func didCreateTask(_ task: URLSessionTask)

    /// URLSessionDataTask가 데이터를 수신했을 때 호출됩니다.
    /// - Parameters:
    ///   - task: 데이터를 수신한 URLSessionDataTask
    ///   - data: 수신한 데이터
    ///
    /// ## 사용 예시
    /// ```swift
    /// interceptor.didReceiveData(task, data: data)
    /// ```
    func didReceiveData(_ task: URLSessionDataTask, data: Data)

    /// URLSessionTask가 완료되었을 때 호출됩니다.
    /// - Parameters:
    ///   - task: 완료된 URLSessionTask
    ///   - error: 에러가 발생한 경우 전달되는 Error 객체 (성공 시 nil)
    ///
    /// ## 사용 예시
    /// ```swift
    /// interceptor.didCompleteTask(task, error: error)
    /// ```
    func didCompleteTask(_ task: URLSessionTask, error: Error?)

    // MARK: - 요청 수정 메서드

    /// 네트워크 요청을 수정합니다.
    ///
    /// Authorization 헤더 추가 등의 요청 수정에 사용됩니다.
    ///
    /// - Parameter context: 요청 컨텍스트 (endpoint + URLRequest)
    /// - Returns: 수정된 요청 컨텍스트
    /// - Throws: 요청 수정 중 발생한 에러
    ///
    /// ## 사용 예시
    /// ```swift
    /// func adapt(_ context: RequestContext) async throws -> RequestContext {
    ///     var newContext = context
    ///     newContext.request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    ///     return newContext
    /// }
    /// ```
    func adapt(_ context: RequestContext) async throws -> RequestContext

    // MARK: - 재시도 결정 메서드

    /// 요청 실패 시 재시도 여부를 결정합니다.
    ///
    /// 401 에러 시 토큰 갱신 후 재시도 등에 사용됩니다.
    ///
    /// - Parameters:
    ///   - context: 요청 컨텍스트
    ///   - error: 발생한 에러
    ///   - attemptCount: 현재 시도 횟수 (1부터 시작)
    /// - Returns: 재시도 결정
    ///
    /// ## 사용 예시
    /// ```swift
    /// func retry(
    ///     _ context: RequestContext,
    ///     dueTo error: Error,
    ///     attemptCount: Int
    /// ) async -> RetryDecision {
    ///     guard attemptCount == 1,
    ///           let networkError = error as? NetworkError,
    ///           networkError == .authorizationError else {
    ///         return .doNotRetry
    ///     }
    ///     // 토큰 갱신 후 재시도
    ///     return .retry(newRequest)
    /// }
    /// ```
    func retry(
        _ context: RequestContext,
        dueTo error: Error,
        attemptCount: Int
    ) async -> RetryDecision
}

// MARK: - Default Implementations

public extension NetworkInterceptor {
    /// 기본 구현: 컨텍스트를 그대로 반환합니다.
    func adapt(_ context: RequestContext) async throws -> RequestContext {
        context
    }

    /// 기본 구현: 재시도하지 않습니다.
    func retry(
        _ context: RequestContext,
        dueTo error: Error,
        attemptCount: Int
    ) async -> RetryDecision {
        .doNotRetry
    }
}
