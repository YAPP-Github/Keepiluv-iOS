//
//  PhotoLogClient.swift
//  DomainPhotoLogInterface
//
//  Created by Codex on 2/6/26.
//.

import ComposableArchitecture

/// 인증샷 업로드/등록을 위한 Client입니다.
public struct PhotoLogClient {
    public var fetchUploadURL: (Int64) async throws -> PhotoLogUploadURLResponseDTO
    public var createPhotoLog: (PhotoLogCreateRequestDTO) async throws -> PhotoLogCreateResponseDTO

    public init(
        fetchUploadURL: @escaping (Int64) async throws -> PhotoLogUploadURLResponseDTO,
        createPhotoLog: @escaping (PhotoLogCreateRequestDTO) async throws -> PhotoLogCreateResponseDTO
    ) {
        self.fetchUploadURL = fetchUploadURL
        self.createPhotoLog = createPhotoLog
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
        }
    )
}

public extension DependencyValues {
    var photoLogClient: PhotoLogClient {
        get { self[PhotoLogClient.self] }
        set { self[PhotoLogClient.self] = newValue }
    }
}
