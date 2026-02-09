//
//  MockNetworkInterceptor.swift
//  CoreNetworkTesting
//
//  Created by Jiyong on 2/9/26.
//

import CoreNetworkInterface
import Foundation

public final class MockNetworkInterceptor: NetworkInterceptor, @unchecked Sendable {
    public var adaptHandler: ((RequestContext) async throws -> RequestContext)?
    public var retryHandler: ((RequestContext, Error, Int) async -> RetryDecision)?

    public private(set) var didCreateTaskCallCount = 0
    public private(set) var didReceiveDataCallCount = 0
    public private(set) var didCompleteTaskCallCount = 0
    public private(set) var adaptCallCount = 0
    public private(set) var retryCallCount = 0

    public init() {}

    public func didCreateTask(_ task: URLSessionTask) {
        didCreateTaskCallCount += 1
    }

    public func didReceiveData(_ task: URLSessionDataTask, data: Data) {
        didReceiveDataCallCount += 1
    }

    public func didCompleteTask(_ task: URLSessionTask, error: Error?) {
        didCompleteTaskCallCount += 1
    }

    public func adapt(_ context: RequestContext) async throws -> RequestContext {
        adaptCallCount += 1
        if let handler = adaptHandler {
            return try await handler(context)
        }
        return context
    }

    public func retry(
        _ context: RequestContext,
        dueTo error: Error,
        attemptCount: Int
    ) async -> RetryDecision {
        retryCallCount += 1
        if let handler = retryHandler {
            return await handler(context, error, attemptCount)
        }
        return .doNotRetry
    }
}
