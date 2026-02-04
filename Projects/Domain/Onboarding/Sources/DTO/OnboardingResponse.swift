//
//  OnboardingResponse.swift
//  DomainOnboarding
//

import DomainOnboardingInterface
import Foundation

/// 초대 코드 조회 응답 DTO
struct InviteCodeResponse: Decodable {
    let inviteCode: String
}

/// 온보딩 상태 조회 응답 DTO
struct OnboardingStatusResponse: Decodable {
    let status: OnboardingStatus
}
