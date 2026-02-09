//
//  PhotoLogCreateResponseDTO.swift
//  DomainPhotoLogInterface
//
//  Created by Codex on 2/6/26.
//

import Foundation

/// 인증샷 등록 응답 DTO입니다.
public struct PhotoLogCreateResponseDTO: Decodable {
    public let photologId: Int
    public let goalId: Int
    public let imageUrl: String
    public let comment: String
    public let verificationDate: String

    public init(
        photologId: Int,
        goalId: Int,
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
