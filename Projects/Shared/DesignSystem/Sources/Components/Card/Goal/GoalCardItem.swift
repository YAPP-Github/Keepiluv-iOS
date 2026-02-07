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
///     id: "1",
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
public struct GoalCardItem: Identifiable, Equatable {
    /// 카드의 개별 셀에 표시할 이미지/이모지 모델입니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let card = GoalCardItem.Card(
    ///     image: SharedDesignSystemAsset.ImageAssets.boy.swiftUIImage,
    ///     emoji: .Icon.Illustration.emoji1
    /// )
    /// ```
    public struct Card: Equatable {
        let imageURL: URL?
        public var isSelected: Bool
        public let emoji: Image?
        
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
            imageURL: URL? = nil,
            isSelected: Bool,
            emoji: Image? = nil
        ) {
            self.imageURL = imageURL
            self.isSelected = isSelected
            self.emoji = emoji
        }
    }
    
    public let id: Int
    public let goalName: String
    public let goalEmoji: Image
    public var myCard: Card
    public var yourCard: Card
    
    /// 목표 카드 데이터를 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let item = GoalCardItem(
    ///     id: "1",
    ///     goalName: "목표 이름",
    ///     goalEmoji: .Icon.Illustration.exercise,
    ///     myCard: .init(image: nil, emoji: nil),
    ///     yourCard: .init(image: nil, emoji: nil)
    /// )
    /// ```
    public init(
        id: Int,
        goalName: String,
        goalEmoji: Image,
        myCard: Card,
        yourCard: Card
    ) {
        self.id = id
        self.goalName = goalName
        self.goalEmoji = goalEmoji
        self.myCard = myCard
        self.yourCard = yourCard
    }
}
