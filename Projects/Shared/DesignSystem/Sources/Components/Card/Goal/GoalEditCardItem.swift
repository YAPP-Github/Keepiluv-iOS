//
//  GoalEditCardItem.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/21/26.
//

import Foundation

/// 목표 편집 카드에 표시할 항목 값을 담는 모델입니다.
///
/// ## 사용 예시
/// ```swift
/// let item = GoalEditCardItem(
///     repeatCycle: "매일",
///     startDate: "yyyy년 m월 d일",
///     endDate: "미설정"
/// )
/// ```
public struct GoalEditCardItem {
    let repeatCycle: String
    let startDate: String
    let endDate: String
    
    /// 반복 주기/시작일/종료일로 GoalEditCardItem을 생성합니다.
    public init(
        repeatCycle: String,
        startDate: String,
        endDate: String
    ) {
        self.repeatCycle = repeatCycle
        self.startDate = startDate
        self.endDate = endDate
    }
}
