//
//  PhotoLogUpdateRequestDTO.swift
//  DomainPhotoLogInterface
//
//  Created by 정지훈 on 2/12/26.
//

import Foundation

/// 인증샷 수정 요청 DTO입니다.
public struct PhotoLogUpdateRequestDTO: Encodable {
    public let fileName: String
    public let comment: String

    public init(
        fileName: String,
        comment: String
    ) {
        self.fileName = fileName
        self.comment = comment
    }
}
