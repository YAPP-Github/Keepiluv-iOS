//
//  AuthInterceptorTests.swift
//  DomainAuthTests
//
//  Created by Jiyong on 2/9/26.
//

import CoreNetworkInterface
import CoreNetworkTesting
import DomainAuth
import DomainAuthInterface
import Foundation
import XCTest

final class AuthInterceptorTests: XCTestCase {

    override func tearDown() async throws {
        await TokenManager.shared.clearToken()
    }

    // MARK: - Adapt Tests

    func test_adapt_skips_header_when_requiresAuth_is_false() async throws {
        let interceptor = AuthInterceptor(
            tokenManager: TokenManager.shared,
            refreshToken: { throw TestError.notCalled }
        )

        let endpoint = MockEndpoint(requiresAuth: false)
        let request = URLRequest(url: URL(string: "https://api.test.com/test")!)
        let context = RequestContext(endpoint: endpoint, request: request)

        let result = try await interceptor.adapt(context)

        XCTAssertNil(result.request.value(forHTTPHeaderField: "Authorization"))
    }

    func test_adapt_adds_authorization_header_when_requiresAuth_is_true() async throws {
        await TokenManager.shared.saveToken(Token(
            accessToken: "test_access_token",
            refreshToken: "test_refresh_token",
            expiresAt: Date().addingTimeInterval(3600)
        ))

        let interceptor = AuthInterceptor(
            tokenManager: TokenManager.shared,
            refreshToken: { throw TestError.notCalled }
        )

        let endpoint = MockEndpoint(requiresAuth: true)
        let request = URLRequest(url: URL(string: "https://api.test.com/test")!)
        let context = RequestContext(endpoint: endpoint, request: request)

        let result = try await interceptor.adapt(context)

        XCTAssertEqual(
            result.request.value(forHTTPHeaderField: "Authorization"),
            "Bearer test_access_token"
        )
    }

    func test_adapt_skips_header_when_no_token() async throws {
        let interceptor = AuthInterceptor(
            tokenManager: TokenManager.shared,
            refreshToken: { throw TestError.notCalled }
        )

        let endpoint = MockEndpoint(requiresAuth: true)
        let request = URLRequest(url: URL(string: "https://api.test.com/test")!)
        let context = RequestContext(endpoint: endpoint, request: request)

        let result = try await interceptor.adapt(context)

        XCTAssertNil(result.request.value(forHTTPHeaderField: "Authorization"))
    }

    // MARK: - Retry Tests

    func test_retry_skips_non_401_errors() async {
        let interceptor = AuthInterceptor(
            tokenManager: TokenManager.shared,
            refreshToken: { throw TestError.notCalled }
        )

        let endpoint = MockEndpoint(requiresAuth: true)
        let request = URLRequest(url: URL(string: "https://api.test.com/test")!)
        let context = RequestContext(endpoint: endpoint, request: request)

        let decision = await interceptor.retry(
            context,
            dueTo: NetworkError.serverError,
            attemptCount: 1
        )

        if case .doNotRetry = decision {
            // success
        } else {
            XCTFail("Expected .doNotRetry for non-401 error")
        }
    }

    func test_retry_skips_when_attemptCount_is_not_1() async {
        let interceptor = AuthInterceptor(
            tokenManager: TokenManager.shared,
            refreshToken: { throw TestError.notCalled }
        )

        let endpoint = MockEndpoint(requiresAuth: true)
        let request = URLRequest(url: URL(string: "https://api.test.com/test")!)
        let context = RequestContext(endpoint: endpoint, request: request)

        let decision = await interceptor.retry(
            context,
            dueTo: NetworkError.authorizationError,
            attemptCount: 2
        )

        if case .doNotRetry = decision {
            // success
        } else {
            XCTFail("Expected .doNotRetry for attemptCount > 1")
        }
    }

    func test_retry_skips_refresh_endpoint() async {
        let interceptor = AuthInterceptor(
            tokenManager: TokenManager.shared,
            refreshToken: { throw TestError.notCalled }
        )

        let endpoint = MockEndpoint(path: "/api/v1/auth/refresh", requiresAuth: false)
        let request = URLRequest(url: URL(string: "https://api.test.com/api/v1/auth/refresh")!)
        let context = RequestContext(endpoint: endpoint, request: request)

        let decision = await interceptor.retry(
            context,
            dueTo: NetworkError.authorizationError,
            attemptCount: 1
        )

        if case .doNotRetry = decision {
            // success
        } else {
            XCTFail("Expected .doNotRetry for refresh endpoint")
        }
    }

    func test_retry_refreshes_token_and_retries_on_401() async {
        let newToken = Token(
            accessToken: "new_access_token",
            refreshToken: "new_refresh_token",
            expiresAt: Date().addingTimeInterval(3600)
        )

        let interceptor = AuthInterceptor(
            tokenManager: TokenManager.shared,
            refreshToken: { newToken }
        )

        let endpoint = MockEndpoint(requiresAuth: true)
        let request = URLRequest(url: URL(string: "https://api.test.com/test")!)
        let context = RequestContext(endpoint: endpoint, request: request)

        let decision = await interceptor.retry(
            context,
            dueTo: NetworkError.authorizationError,
            attemptCount: 1
        )

        if case .retry(let newRequest) = decision {
            XCTAssertEqual(
                newRequest.value(forHTTPHeaderField: "Authorization"),
                "Bearer new_access_token"
            )
        } else {
            XCTFail("Expected .retry with new token")
        }
    }

    func test_retry_does_not_retry_when_refresh_fails() async {
        let interceptor = AuthInterceptor(
            tokenManager: TokenManager.shared,
            refreshToken: { throw TestError.refreshFailed }
        )

        let endpoint = MockEndpoint(requiresAuth: true)
        let request = URLRequest(url: URL(string: "https://api.test.com/test")!)
        let context = RequestContext(endpoint: endpoint, request: request)

        let decision = await interceptor.retry(
            context,
            dueTo: NetworkError.authorizationError,
            attemptCount: 1
        )

        if case .doNotRetry = decision {
            // success
        } else {
            XCTFail("Expected .doNotRetry when refresh fails")
        }
    }
}

// MARK: - Test Helpers

private enum TestError: Error {
    case notCalled
    case refreshFailed
}
