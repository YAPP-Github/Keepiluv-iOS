//
//  Goal.swift
//  DomainGoalInterface
//
//  Created by 정지훈 on 1/26/26.
//

import SwiftUI

/// 목표 카드에 표시할 목표 데이터 모델입니다.
///
/// ## 사용 예시
/// ```swift
/// let goal = Goal(
///     id: "1",
///     goalIcon: .Icon.Illustration.exercise,
///     title: "목표 1111111",
///     isCompleted: false,
///     image: nil,
///     emoji: .Icon.Illustration.emoji1
/// )
/// ```
public struct Goal {
    // TODO: - Image로 임시 대체 후 Data로 타입 변경
    public let id: String
    public let goalIcon: Image
    public let title: String
    public let isCompleted: Bool
    public var image: Image?
    public var emoji: Image?
    
    /// 목표 데이터를 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let goal = Goal(
    ///     id: "1",
    ///     goalIcon: .Icon.Illustration.exercise,
    ///     title: "목표 1111111",
    ///     isCompleted: false,
    ///     image: nil,
    ///     emoji: .Icon.Illustration.emoji1
    /// )
    /// ```
    public init(
        id: String,
        goalIcon: Image,
        title: String,
        isCompleted: Bool,
        image: Image? = nil,
        emoji: Image? = nil
    ) {
        self.id = id
        self.goalIcon = goalIcon
        self.title = title
        self.isCompleted = isCompleted
        self.image = image
        self.emoji = emoji
    }
}
