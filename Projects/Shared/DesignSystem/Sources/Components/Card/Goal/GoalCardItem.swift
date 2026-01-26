//
//  GoalCardItem.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/20/26.
//

import SwiftUI

/// 목표 카드 한 장을 구성하는 모델입니다.
///
/// ## 사용 예시
/// ```swift
/// let item = GoalCardItem(
///     goalName: "목표 이름",
///     goalEmoji: .Icon.Illustration.exercise,
///     myCard: .init(
///         image: SharedDesignSystemAsset.ImageAssets.boy.swiftUIImage,
///         emoji: .Icon.Illustration.emoji1
///     ),
///     yourCard: .init(
///         image: nil,
///         emoji: nil
///     )
/// )
/// ```
public struct GoalCardItem: Identifiable {
    /// 카드의 개별 셀에 표시할 이미지/이모지 모델입니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let card = GoalCardItem.Card(
    ///     image: SharedDesignSystemAsset.ImageAssets.boy.swiftUIImage,
    ///     emoji: .Icon.Illustration.emoji1
    /// )
    /// ```
    public struct Card {
        let image: Image?
        let emoji: Image?
        public var isSelected: Bool
        
        /// 이미지/이모지로 GoalCardItem.Card를 생성합니다.
        ///
        /// ## 사용 예시
        /// ```swift
        /// let card = GoalCardItem.Card(
        ///     image: SharedDesignSystemAsset.ImageAssets.boy.swiftUIImage,
        ///     emoji: .Icon.Illustration.emoji1
        /// )
        /// ```
        public init(
            image: Image?,
            emoji: Image? = nil,
            isSelected: Bool
        ) {
            self.image = image
            self.emoji = emoji
            self.isSelected = isSelected
        }
    }
    
    public let id: UUID
    public let goalName: String
    public let goalEmoji: Image
    public var myCard: Card
    public var yourCard: Card
    
    /// 목표 카드 데이터를 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let item = GoalCardItem(
    ///     goalName: "목표 이름",
    ///     goalEmoji: .Icon.Illustration.exercise,
    ///     myCard: .init(image: nil, emoji: nil),
    ///     yourCard: .init(image: nil, emoji: nil)
    /// )
    /// ```
    public init(
        goalName: String,
        goalEmoji: Image,
        myCard: Card,
        yourCard: Card
    ) {
        self.id = UUID()
        self.goalName = goalName
        self.goalEmoji = goalEmoji
        self.myCard = myCard
        self.yourCard = yourCard
    }
}
