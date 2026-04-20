//
//  StampColor.swift
//  DomainCommonInterface
//
//  Created by 정지훈 on 4/20/26.
//

import Foundation

/// 통계 스탬프 색상을 나타내는 공통 비즈니스 enum입니다.
///
/// API 응답과 도메인 모델에서는 이 타입을 사용하고, 실제 렌더링 색상으로의 변환은
/// Feature 또는 DesignSystem 경계에서 처리합니다.
public enum StampColor: String, Equatable, CaseIterable {
    case green400 = "GREEN400"
    case blue400 = "BLUE400"
    case yellow400 = "YELLOW400"
    case pink400 = "PINK400"
    case pink300 = "PINK300"
    case pink200 = "PINK200"
    case orange400 = "ORANGE400"
    case purple400 = "PURPLE400"
}
