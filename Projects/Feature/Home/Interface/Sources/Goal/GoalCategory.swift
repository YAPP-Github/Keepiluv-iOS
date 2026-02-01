//
//  GoalCategory.swift
//  FeatureHome
//
//  Created by 정지훈 on 1/31/26.
//

import SwiftUI

/// 홈에서 사용되는 목표 카테고리를 정의합니다.
///
/// ## 사용 예시
/// ```swift
/// let category = GoalCategory.health
/// print(category.title)
/// ```
public enum GoalCategory: CaseIterable, Equatable {
    case custom
    case health
    case vitamin
    case walk
    case book
    case cleaning
    case call
}

/// 목표 반복 주기를 표현하는 타입입니다.
///
/// ## 사용 예시
/// ```swift
/// let cycle = RepeatCycle.weekly(count: 3)
/// print(cycle.count)
/// ```
public enum RepeatCycle {
    case daily
    case weekly(count: Int)
    case monthly(count: Int)
}

extension RepeatCycle {
    public var count: Int {
        switch self {
        case .daily: return 0
        case let .weekly(count): return count
        case let .monthly(count): return count
        }
    }
}

extension GoalCategory {
    public var title: String {
        switch self {
        case .custom: "직접 만들기"
        case .health: "헬스하기"
        case .vitamin: "매일 비타민 챙겨먹기"
        case .walk: "집 앞 산책"
        case .book: "책 읽기!"
        case .cleaning: "집 대청소"
        case .call: "집 가는길에 전화걸기"
        }
    }
    
    public var icon: Image {
        switch self {
        case .custom: .Icon.Illustration.add
        case .health: .Icon.Illustration.drug
        case .vitamin: .Icon.Illustration.drug
        case .walk: .Icon.Illustration.drug
        case .book: .Icon.Illustration.drug
        case .cleaning: .Icon.Illustration.drug
        case .call: .Icon.Illustration.drug
        }
    }
    
    public var repeatCycle: RepeatCycle {
        switch self {
        case .custom: .daily
        case .health: .weekly(count: 3)
        case .vitamin: .daily
        case .walk: .monthly(count: 2)
        case .book: .monthly(count: 4)
        case .cleaning: .weekly(count: 1)
        case .call: .daily
        }
    }
}
