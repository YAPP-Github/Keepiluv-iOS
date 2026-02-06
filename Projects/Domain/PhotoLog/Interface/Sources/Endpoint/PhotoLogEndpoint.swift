//
//  PhotoLogEndpoint.swift
//  DomainPhotoLogInterface
//
//  Created by Codex on 2/6/26.
//

import Foundation

import CoreNetworkInterface

/// 인증샷 관련 API 엔드포인트 정의입니다.
public enum PhotoLogEndpoint: Endpoint {
    case fetchUploadURL(goalId: Int)
    case createPhotoLog(PhotoLogCreateRequestDTO)
}

extension PhotoLogEndpoint {
    public var baseURL: URL {
        guard let urlString = Configuration.apiBaseURL,
              let url = URL(string: urlString) else {
            return Configuration.fallbackURL
        }
        return url
    }

    public var path: String {
        switch self {
        case .fetchUploadURL: return "/api/v1/photologs/upload-url"
        case .createPhotoLog: return "/api/v1/photologs"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .fetchUploadURL: return .get
        case .createPhotoLog: return .post
        }
    }

    public var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }

    public var query: [URLQueryItem]? {
        switch self {
        case let .fetchUploadURL(goalId):
            return [URLQueryItem(name: "goalId", value: String(goalId))]
        case .createPhotoLog:
            return nil
        }
    }

    public var body: (any Encodable)? {
        switch self {
        case .fetchUploadURL:
            return nil
        case let .createPhotoLog(request):
            return request
        }
    }

    public var requiresAuth: Bool { true }
    public var featureTag: FeatureTag { .photoLog }
}

// MARK: - Configuration

private enum Configuration {
    static let fallbackURL = URL(string: "https://httpbin.org")! // swiftlint:disable:this force_unwrapping

    static var apiBaseURL: String? {
        ProcessInfo.processInfo.environment["API_BASE_URL"] ??
        Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String
    }
}
