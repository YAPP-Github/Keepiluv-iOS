//
//  RepeatCycle+Text.swift
//  FeatureCommonInterface
//
//  Created by 정지훈 on 4/20/26.
//

import DomainCommonInterface

public extension RepeatCycle {
    /// 반복 주기의 현재 표시 문구를 반환합니다.
    ///
    /// 공통 도메인 값을 여러 Feature에서 같은 방식으로 보여주기 위한
    /// 단기 표시 정책이며, 실제 문자열 소유 책임은 Domain이 아니라 Feature에 둡니다.
    var text: String {
        switch self {
        case .daily: "매일"
        case .weekly: "매주"
        case .monthly: "매월"
        }
    }
}
