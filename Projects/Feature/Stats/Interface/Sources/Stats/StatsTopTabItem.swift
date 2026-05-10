//
//  StatsTopTabItem.swift
//  FeatureStatsInterface
//
//  Created by 정지훈 on 4/20/26.
//

import SharedDesignSystem

/// 통계 메인 화면 상단 탭에서 사용하는 선택 아이템입니다.
public enum StatsTopTabItem: TXItem {
    case ongoing
    case completed

    public var title: String {
        switch self {
        case .ongoing: return "진행중"
        case .completed: return "종료"
        }
    }
}
