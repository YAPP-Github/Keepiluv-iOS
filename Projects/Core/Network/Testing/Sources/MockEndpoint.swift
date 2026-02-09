//
//  MockEndpoint.swift
//  CoreNetworkTesting
//
//  Created by Jiyong on 2/9/26.
//

import CoreNetworkInterface
import Foundation

public struct MockEndpoint: Endpoint {
    public var baseURL: URL
    public var path: String
    public var method: HTTPMethod
    public var headers: [String: String]?
    public var query: [URLQueryItem]?
    public var body: Encodable?
    public var requiresAuth: Bool
    public var featureTag: FeatureTag

    public init(
        baseURL: URL = URL(string: "https://api.test.com")!,
        path: String = "/test",
        method: HTTPMethod = .get,
        headers: [String: String]? = nil,
        query: [URLQueryItem]? = nil,
        body: Encodable? = nil,
        requiresAuth: Bool = false,
        featureTag: FeatureTag = .unknown
    ) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.headers = headers
        self.query = query
        self.body = body
        self.requiresAuth = requiresAuth
        self.featureTag = featureTag
    }
}
