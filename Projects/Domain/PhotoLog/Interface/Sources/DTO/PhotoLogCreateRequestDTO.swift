//
//  PhotoLogCreateRequestDTO.swift
//  DomainPhotoLogInterface
//
//  Created by Codex on 2/6/26.
//

import Foundation

/// 인증샷 등록 요청 DTO입니다.
public struct PhotoLogCreateRequestDTO: Encodable {
    public let goalId: Int
    public let fileName: String
    public let comment: String
    public let verificationDate: String

    public init(
        goalId: Int,
        fileName: String,
        comment: String,
        verificationDate: String
    ) {
        self.goalId = goalId
        self.fileName = fileName
        self.comment = comment
        self.verificationDate = verificationDate
    }
}
