//
//  DetailCompltedItem.swift
//  FeatureGoalDetail
//
//  Created by 정지훈 on 1/21/26.
//

import SwiftUI

/// GoalDetail 화면에서 사용하는 완료 아이템 모델입니다.
public struct DetailCompletedItem {
    public let image: Image
    public let commentText: String
    public let createdAt: String
    public let selectedEmojiIndex: Int?
    public let name: String
    
    /// 아이템을 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let item = DetailCompltedItem(
    ///     image: image,
    ///     commentText: "차타고슝슝",
    ///     createdAt: "6시간전",
    ///     selectedEmojiIndex: nil,
    ///     name: "민정"
    /// )
    /// ```
    public init(
        image: Image,
        commentText: String,
        createdAt: String,
        selectedEmojiIndex: Int?,
        name: String
    ) {
        self.image = image
        self.commentText = commentText
        self.createdAt = createdAt
        self.selectedEmojiIndex = selectedEmojiIndex
        self.name = name
    }
}
