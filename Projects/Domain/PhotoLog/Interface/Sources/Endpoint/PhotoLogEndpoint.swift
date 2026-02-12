//
//  PhotoLogEndpoint.swift
//  DomainPhotoLogInterface
//
//  Created by Codex on 2/6/26.
//

import Foundation

import CoreNetworkInterface

/// 인증샷 관련 API 엔드포인트 정의입니다.
///
/// ## 사용 예시
/// ```swift
/// let request = PhotoLogUpdateReactionRequestDTO(reaction: "EMOJI_HAPPY")
/// let endpoint = PhotoLogEndpoint.updateReaction(photoLogId: 1, request: request)
/// ```
public enum PhotoLogEndpoint: Endpoint {
    case fetchUploadURL(goalId: Int64)
    case createPhotoLog(PhotoLogCreateRequestDTO)
    case updateReaction(photoLogId: Int64, request: PhotoLogUpdateReactionRequestDTO)
    case updatePhotoLog(photoLogId: Int64, request: PhotoLogUpdateRequestDTO)
    case deletePhotoLog(photoLogId: Int64)
}

extension PhotoLogEndpoint {
    public var path: String {
        switch self {
        case .fetchUploadURL: return "/api/v1/photologs/upload-url"
        case .createPhotoLog: return "/api/v1/photologs"
        case let .updateReaction(photoLogId, _): return "/api/v1/photologs/\(photoLogId)/reaction"
        case let .updatePhotoLog(photoLogId, _): return "/api/v1/photologs/\(photoLogId)"
        case let .deletePhotoLog(photoLogId): return "/api/v1/photologs/\(photoLogId)"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .fetchUploadURL: return .get
        case .createPhotoLog: return .post
        case .updateReaction: return .put
        case .updatePhotoLog: return .put
        case .deletePhotoLog: return .delete
        }
    }

    public var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }

    public var query: [URLQueryItem]? {
        switch self {
        case let .fetchUploadURL(goalId):
            return [URLQueryItem(name: "goalId", value: String(goalId))]

        case .createPhotoLog, .updateReaction, .deletePhotoLog, .updatePhotoLog:
            return nil
        }
    }

    public var body: (any Encodable)? {
        switch self {
        case .fetchUploadURL:
            return nil

        case let .createPhotoLog(request):
            return request

        case let .updateReaction(_, request):
            return request

        case let .updatePhotoLog(_, request):
            return request
          
        case .deletePhotoLog:
            return nil
        }
    }

    public var requiresAuth: Bool { true }
    public var featureTag: FeatureTag { .proopPhoto }
}
