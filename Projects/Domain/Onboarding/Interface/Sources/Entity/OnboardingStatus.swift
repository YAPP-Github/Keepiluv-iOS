//
//  OnboardingStatus.swift
//  DomainOnboardingInterface
//

import Foundation

/// 온보딩 진행 상태를 나타내는 열거형입니다.
public enum OnboardingStatus: String, Equatable, Sendable, Codable {
    case coupleConnection = "COUPLE_CONNECTION"
    case profile = "PROFILE"
    case anniversary = "ANNIVERSARY"
    case completed = "COMPLETED"
}
