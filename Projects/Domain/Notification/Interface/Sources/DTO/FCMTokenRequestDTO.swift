//
//  FCMTokenRequestDTO.swift
//  DomainNotificationInterface
//
//  Created by Jiyong on 02/21/26.
//

import Foundation

/// FCM 토큰 등록 요청 DTO입니다.
public struct FCMTokenRequestDTO: Encodable, Sendable {
    public let token: String
    public let deviceId: String

    public init(token: String, deviceId: String) {
        self.token = token
        self.deviceId = deviceId
    }
}

/// FCM 토큰 삭제 요청 DTO입니다.
public struct FCMTokenDeleteRequestDTO: Encodable, Sendable {
    public let token: String

    public init(token: String) {
        self.token = token
    }
}
