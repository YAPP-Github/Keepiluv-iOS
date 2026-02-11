//
//  PhotoLogClient+Live.swift
//  DomainPhotoLog
//
//  Created by Codex on 2/6/26.
//

import ComposableArchitecture
import CoreNetworkInterface
import DomainPhotoLogInterface

extension PhotoLogClient: @retroactive DependencyKey {
    public static let liveValue: PhotoLogClient = .live()

    /// PhotoLogClient의 기본 구현입니다.
    static func live() -> PhotoLogClient {
        @Dependency(\.networkClient) var networkClient

        return .init(
            fetchUploadURL: { goalId in
                let response: PhotoLogUploadURLResponseDTO = try await networkClient.request(
                    endpoint: PhotoLogEndpoint.fetchUploadURL(goalId: goalId)
                )
                return response
            },
            createPhotoLog: { request in
                let response: PhotoLogCreateResponseDTO = try await networkClient.request(
                    endpoint: PhotoLogEndpoint.createPhotoLog(request)
                )
                return response
            },
            updateReaction: { photoLogId, request in
                let response: PhotoLogUpdateReactionResponseDTO = try await networkClient.request(
                    endpoint: PhotoLogEndpoint.updateReaction(photoLogId: photoLogId, request: request)
                )
                return response
            }
        )
    }
}
