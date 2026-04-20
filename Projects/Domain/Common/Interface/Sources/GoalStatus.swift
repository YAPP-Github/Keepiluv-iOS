//
//  GoalStatus.swift
//  DomainCommonInterface
//
//  Created by 정지훈 on 4/20/26.
//

import Foundation

/// 목표 진행 상태를 나타내는 공통 비즈니스 enum입니다.
///
/// 특정 Feature의 표시 문구와 분리하고, DTO 매핑과 도메인 엔티티에서
/// 동일한 상태 값을 재사용하기 위해 `DomainCommonInterface`에서 관리합니다.
public enum GoalStatus: String, Equatable {
    case notStarted = "NOT_STARTED"
    case inProgressed = "IN_PROGRESSED"
    case completed = "COMPLETED"
}
