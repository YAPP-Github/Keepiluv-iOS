//
//  TXInfoModalContent+Configuration.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 2/4/26.
//

import Foundation

public extension TXInfoModalContent.Configuration {
    /// 목표 삭제 확인용 정보 모달 설정입니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// TXInfoModalContent(config: .deleteGoal)
    /// ```
    static var deleteGoal: Self {
        return .init(
            image: .Icon.Illustration.emoji2,
            title: "목표를 이루셨나요?",
            subtitle: "목표를 완료해도 사진은 사라지지 않아요",
            leftButtonText: "취소",
            rightButtonText: "삭제"
        )
    }
    
    /// 목표 완료 확인용 정보 모달 설정을 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let config = TXInfoModalContent.Configuration.finishGoal(for: card)
    /// ```
    static func finishGoal(for card: GoalEditCardItem) -> Self {
        return .init(
            image: card.iconImage,
            title: "\(card.goalName)\n목표를 이루셨나요?",
            subtitle: "이룬 목표에서 확인할 수 있어요",
            leftButtonText: "취소",
            rightButtonText: "이뤘어요"
        )
    }
    
    static func editDeleteGoal(for card: GoalEditCardItem) -> Self {
        return .init(
            image: card.iconImage,
            title: "\(card.goalName)\n목표를 삭제할까요?",
            subtitle: "저장된 인증샷은 모두 삭제됩니다.",
            leftButtonText: "취소",
            rightButtonText: "삭제"
        )
    }
}
