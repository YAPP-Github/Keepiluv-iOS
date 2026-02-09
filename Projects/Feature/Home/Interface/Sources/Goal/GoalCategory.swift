//
//  GoalCategory.swift
//  FeatureHome
//
//  Created by 정지훈 on 1/31/26.
//

import SwiftUI

import DomainGoalInterface

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
        case .health: .Icon.Illustration.exercise
        case .vitamin: .Icon.Illustration.health
        case .walk: .Icon.Illustration.default
        case .book: .Icon.Illustration.book
        case .cleaning: .Icon.Illustration.clean
        case .call: .Icon.Illustration.heartDouble
        }
    }
    
    public var repeatCycle: Goal.RepeatCycle {
        switch self {
        case .custom: .daily
        case .health: .weekly
        case .vitamin: .daily
        case .walk: .monthly
        case .book: .monthly
        case .cleaning: .weekly
        case .call: .daily
        }
    }
    
    public var repeatCount: Int {
        switch self {
        case .custom: 0
        case .health: 3
        case .vitamin: 0
        case .walk: 2
        case .book: 4
        case .cleaning: 1
        case .call: 0
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
