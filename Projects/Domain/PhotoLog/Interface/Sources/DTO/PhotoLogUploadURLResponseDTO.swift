//
//  PhotoLogUploadURLResponseDTO.swift
//  DomainPhotoLogInterface
//
//  Created by Codex on 2/6/26.
//

import Foundation

/// 인증샷 업로드 URL 발급 응답 DTO입니다.
public struct PhotoLogUploadURLResponseDTO: Decodable {
    public let uploadUrl: String
    public let fileName: String

    public init(
        uploadUrl: String,
        fileName: String
    ) {
        self.uploadUrl = uploadUrl
        self.fileName = fileName
    }
}
