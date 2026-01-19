//
//  AuthProvider.swift
//  DomainAuthInterface
//
//  Created by Jiyong
//

import Foundation

/// 소셜 로그인 제공자를 나타내는 타입입니다.
public enum AuthProvider: String, Equatable, Sendable {
    case apple
    case kakao
    case google
}
