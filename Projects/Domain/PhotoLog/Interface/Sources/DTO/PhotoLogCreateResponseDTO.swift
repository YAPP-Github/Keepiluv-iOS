//
//  PhotoLogCreateResponseDTO.swift
//  DomainPhotoLogInterface
//
//  Created by Codex on 2/6/26.
//

import Foundation

/// 인증샷 등록 응답 DTO입니다.
public struct PhotoLogCreateResponseDTO: Decodable {
    public let photologId: Int64
    public let goalId: Int64
    public let imageUrl: String
    public let comment: String
    public let verificationDate: String

    public init(
        photologId: Int64,
        goalId: Int64,
        imageUrl: String,
        comment: String,
        verificationDate: String
    ) {
        self.photologId = photologId
        self.goalId = goalId
        self.imageUrl = imageUrl
        self.comment = comment
        self.verificationDate = verificationDate
    }
}
