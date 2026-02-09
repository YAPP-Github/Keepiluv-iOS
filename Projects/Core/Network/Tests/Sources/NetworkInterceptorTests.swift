//
//  NetworkInterceptorTests.swift
//  CoreNetworkTests
//
//  Created by Jiyong on 2/9/26.
//

import CoreNetwork
import CoreNetworkInterface
import CoreNetworkTesting
import Foundation
import XCTest

final class NetworkInterceptorTests: XCTestCase {

    // MARK: - Adapt Tests

    func test_adapt_modifies_request_headers() async throws {
        let interceptor = MockNetworkInterceptor()
        interceptor.adaptHandler = { context in
            var newContext = context
            newContext.request.setValue("TestValue", forHTTPHeaderField: "X-Custom-Header")
            return newContext
        }

        let endpoint = MockEndpoint()
        let request = URLRequest(url: URL(string: "https://api.test.com/test")!)
        let context = RequestContext(endpoint: endpoint, request: request)

        let result = try await interceptor.adapt(context)

        XCTAssertEqual(result.request.value(forHTTPHeaderField: "X-Custom-Header"), "TestValue")
        XCTAssertEqual(interceptor.adaptCallCount, 1)
    }

    func test_adapt_default_implementation_returns_context_unchanged() async throws {
        let interceptor = MockNetworkInterceptor()

        let endpoint = MockEndpoint()
        let request = URLRequest(url: URL(string: "https://api.test.com/test")!)
        let context = RequestContext(endpoint: endpoint, request: request)

        let result = try await interceptor.adapt(context)

        XCTAssertEqual(result.request.url, context.request.url)
    }

    // MARK: - Retry Tests

    func test_retry_default_implementation_returns_doNotRetry() async {
        let interceptor = MockNetworkInterceptor()

        let endpoint = MockEndpoint()
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
            XCTFail("Expected .doNotRetry")
        }
    }

    func test_retry_returns_retry_with_new_request() async {
        let interceptor = MockNetworkInterceptor()
        interceptor.retryHandler = { context, _, _ in
            var newRequest = context.request
            newRequest.setValue("NewToken", forHTTPHeaderField: "Authorization")
            return .retry(newRequest)
        }

        let endpoint = MockEndpoint()
        let request = URLRequest(url: URL(string: "https://api.test.com/test")!)
        let context = RequestContext(endpoint: endpoint, request: request)

        let decision = await interceptor.retry(
            context,
            dueTo: NetworkError.authorizationError,
            attemptCount: 1
        )

        if case .retry(let newRequest) = decision {
            XCTAssertEqual(newRequest.value(forHTTPHeaderField: "Authorization"), "NewToken")
        } else {
            XCTFail("Expected .retry")
        }
        XCTAssertEqual(interceptor.retryCallCount, 1)
    }
}
