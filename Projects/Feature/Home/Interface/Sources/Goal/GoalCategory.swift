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

    /// 목표 반복 주기를 표현하는 타입입니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let cycle = RepeatCycle.weekly(count: 3)
    /// print(cycle.count)
    /// ```
    public enum RepeatCycle: Equatable {
        case daily
        case weekly(count: Int)
        case monthly(count: Int)
    }
}

extension GoalCategory {
    public static let images: [Image] = [
        .Icon.Illustration.default,
        .Icon.Illustration.clean,
        .Icon.Illustration.exercise,
        .Icon.Illustration.book,
        .Icon.Illustration.pencil,
        .Icon.Illustration.health,
        .Icon.Illustration.heartDouble,
        .Icon.Illustration.laptop
    ]
    
    
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
        case .health: .Icon.Illustration.exercise
        case .vitamin: .Icon.Illustration.health
        case .walk: .Icon.Illustration.default
        case .book: .Icon.Illustration.book
        case .cleaning: .Icon.Illustration.clean
        case .call: .Icon.Illustration.heartDouble
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
    
    public var iconIndex: Int {
        switch self {
        case .custom: 0
        case .health: 2
        case .vitamin: 5
        case .walk: 0
        case .book: 3
        case .cleaning: 1
        case .call: 6
        }
    }
}


extension GoalCategory.RepeatCycle {
    public var isDaily: Bool {
        if case .daily = self { return true }
        return false
    }

    public var isWeekly: Bool {
        if case .weekly = self { return true }
        return false
    }

    public var isMonthly: Bool {
        if case .monthly = self { return true }
        return false
    }

    public var count: Int {
        switch self {
        case .daily: return 0
        case let .weekly(count): return count
        case let .monthly(count): return count
        }
    }
    
    public var text: String {
        switch self {
        case .daily: return "매일"
        case .weekly: return "매주"
        case .monthly: return "매월"
        }
    }
}
