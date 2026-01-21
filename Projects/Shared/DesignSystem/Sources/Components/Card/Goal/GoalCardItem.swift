//
//  GoalCardItem.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/20/26.
//

import SwiftUI

/// 목표 카드의 개별 셀에 표시할 이미지/이모지를 담는 모델입니다.
///
/// ## 사용 예시
/// ```swift
/// let item = GoalCardItem(
///     image: SharedDesignSystemAsset.ImageAssets.boy.swiftUIImage,
///     emoji: .Icon.Illustration.emoji1
/// )
/// ```
public struct GoalCardItem {
    let image: Image?
    let emoji: Image?
    
    /// 이미지/이모지로 GoalCardItem을 생성합니다.
    public init(
        image: Image?,
        emoji: Image? = nil,
    ) {
        self.image = image
        self.emoji = emoji
    }
}
