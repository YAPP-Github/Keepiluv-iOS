//
//  RepeatCycle.swift
//  DomainCommonInterface
//
//  Created by 정지훈 on 4/20/26.
//

import Foundation

/// 목표 반복 주기를 나타내는 공통 비즈니스 enum입니다.
///
/// `Goal`, `Stats`처럼 동일한 반복 주기 의미를 공유하는 도메인 모델이
/// 하나의 타입만 참조하도록 `DomainCommonInterface`에서 소유합니다.
public enum RepeatCycle: String, Equatable {
    case daily = "DAILY"
    case weekly = "WEEKLY"
    case monthly = "MONTHLY"
}
