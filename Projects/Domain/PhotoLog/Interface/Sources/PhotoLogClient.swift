//
//  PhotoLogClient.swift
//  DomainPhotoLogInterface
//
//  Created by Codex on 2/6/26.
//.

import ComposableArchitecture

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
    public var createPhotoLog: (PhotoLogCreateRequestDTO) async throws -> PhotoLogCreateResponseDTO
    public var updateReaction: (Int64, PhotoLogUpdateReactionRequestDTO) async throws -> PhotoLogUpdateReactionResponseDTO
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
        createPhotoLog: @escaping (PhotoLogCreateRequestDTO) async throws -> PhotoLogCreateResponseDTO,
        updateReaction: @escaping (Int64, PhotoLogUpdateReactionRequestDTO) async throws -> PhotoLogUpdateReactionResponseDTO,
        deletePhotoLog: @escaping (Int64) async throws -> Void
    ) {
        self.fetchUploadURL = fetchUploadURL
        self.createPhotoLog = createPhotoLog
        self.updateReaction = updateReaction
        self.deletePhotoLog = deletePhotoLog
    }
}

extension PhotoLogClient: TestDependencyKey {
    public static let testValue: PhotoLogClient = Self(
        fetchUploadURL: { _ in
            assertionFailure("PhotoLogClient.fetchUploadURL이 구현되지 않았습니다. withDependencies로 mock을 주입하세요.")
            return .init(uploadUrl: "", fileName: "")
        },
        createPhotoLog: { _ in
            assertionFailure("PhotoLogClient.createPhotoLog이 구현되지 않았습니다. withDependencies로 mock을 주입하세요.")
            return .init(photologId: 0, goalId: 0, imageUrl: "", comment: "", verificationDate: "")
        },
        updateReaction: { _, _ in
            assertionFailure("PhotoLogClient.updateReaction이 구현되지 않았습니다. withDependencies로 mock을 주입하세요.")
            return .init(photologId: 0, reaction: "")
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
