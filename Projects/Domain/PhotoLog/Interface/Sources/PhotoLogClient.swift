//
//  PhotoLogClient.swift
//  DomainPhotoLogInterface
//
//  Created by Jihun on 2/6/26.
//

import ComposableArchitecture
import Foundation

/// 인증샷 업로드/등록/리액션 수정을 위한 Client입니다.
///
/// ## 사용 예시
/// ```swift
/// @Dependency(\.photoLogClient) var photoLogClient
/// let request = PhotoLogUpdateReactionRequestDTO(reaction: "EMOJI_HAPPY")
/// let response = try await photoLogClient.updateReaction(1, request)
/// ```
public struct PhotoLogClient {
    public var fetchUploadURL: (Int64) async throws -> PhotoLogUploadURLResponseDTO
    public var uploadImageData: (Data, String) async throws -> Void
    public var createPhotoLog: (PhotoLogCreateRequestDTO) async throws -> PhotoLogCreateResponseDTO
    public var updateReaction: (Int64, PhotoLogUpdateReactionRequestDTO) async throws -> PhotoLogUpdateReactionResponseDTO
    public var updatePhotoLog: (Int64, PhotoLogUpdateRequestDTO) async throws -> Void
    public var deletePhotoLog: (Int64) async throws -> Void

    /// PhotoLogClient를 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let client = PhotoLogClient(
    ///     fetchUploadURL: { _ in .init(uploadUrl: "", fileName: "") },
    ///     createPhotoLog: { _ in .init(photologId: 0, goalId: 0, imageUrl: "", comment: "", verificationDate: "") },
    ///     updateReaction: { _, _ in .init(photologId: 0, reaction: "EMOJI_HAPPY") },
    ///     deletePhotoLog: { _ in }
    /// )
    /// ```
    public init(
        fetchUploadURL: @escaping (Int64) async throws -> PhotoLogUploadURLResponseDTO,
        uploadImageData: @escaping (Data, String) async throws -> Void,
        createPhotoLog: @escaping (PhotoLogCreateRequestDTO) async throws -> PhotoLogCreateResponseDTO,
        updateReaction: @escaping (Int64, PhotoLogUpdateReactionRequestDTO) async throws -> PhotoLogUpdateReactionResponseDTO,
        updatePhotoLog: @escaping (Int64, PhotoLogUpdateRequestDTO) async throws -> Void,
        deletePhotoLog: @escaping (Int64) async throws -> Void
    ) {
        self.fetchUploadURL = fetchUploadURL
        self.uploadImageData = uploadImageData
        self.createPhotoLog = createPhotoLog
        self.updateReaction = updateReaction
        self.updatePhotoLog = updatePhotoLog
        self.deletePhotoLog = deletePhotoLog
    }
}

extension PhotoLogClient: TestDependencyKey {
    public static let testValue: PhotoLogClient = Self(
        fetchUploadURL: { _ in
            assertionFailure("PhotoLogClient.fetchUploadURL이 구현되지 않았습니다. withDependencies로 mock을 주입하세요.")
            return .init(uploadUrl: "", fileName: "")
        },
        uploadImageData: { _, _ in
            assertionFailure("PhotoLogClient.uploadImageData가 구현되지 않았습니다. withDependencies로 mock을 주입하세요.")
        },
        createPhotoLog: { _ in
            assertionFailure("PhotoLogClient.createPhotoLog이 구현되지 않았습니다. withDependencies로 mock을 주입하세요.")
            return .init(photologId: 0, goalId: 0, imageUrl: "", comment: "", verificationDate: "")
        },
        updateReaction: { _, _ in
            assertionFailure("PhotoLogClient.updateReaction이 구현되지 않았습니다. withDependencies로 mock을 주입하세요.")
            return .init(photologId: 0, reaction: "")
        },
        updatePhotoLog: { _, _ in
            assertionFailure("PhotoLogClient.updatePhotoLog이 구현되지 않았습니다. withDependencies로 mock을 주입하세요.")
        },
        deletePhotoLog: { _ in
            assertionFailure("PhotoLogClient.deletePhotoLog이 구현되지 않았습니다. withDependencies로 mock을 주입하세요.")
        }
    )
}

public extension DependencyValues {
    var photoLogClient: PhotoLogClient {
        get { self[PhotoLogClient.self] }
        set { self[PhotoLogClient.self] = newValue }
    }
}
