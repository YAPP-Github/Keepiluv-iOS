//
//  TXInfoModalContent+Configuration.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 2/4/26.
//

import Foundation

public extension TXInfoModalContent.Configuration {
    static var uncheckGoal: Self {
        return .init(
            image: .Icon.Illustration.modalWarning,
            title: "체크를 해제할까요?",
            subtitle: "해제하면 등록한 사진은 사라집니다.",
            leftButtonText: "취소",
            rightButtonText: "해제"
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
    
    /// 목표 삭제 확인용 정보 모달 설정을 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let config = TXInfoModalContent.Configuration.editDeleteGoal(for: card)
    /// ```
    static func editDeleteGoal(for card: GoalEditCardItem) -> Self {
        return .init(
            image: card.iconImage,
            title: "\(card.goalName)\n목표를 삭제할까요?",
            subtitle: "저장된 인증샷은 모두 삭제됩니다.",
            leftButtonText: "취소",
            rightButtonText: "삭제"
        )
    }

    static var disconnectCouple: Self {
        return .init(
            image: .Icon.Illustration.modalWarning,
            title: "정말 커플을 끊으시겠어요?",
            subtitle: """
            오늘부로 30일 후, 모든 데이터가 삭제됩니다.
            복구 가능 기간은 30일 이내입니다.
            복구 희망시 ttwixteamm@gmail.com로
            문의해 주시기 바랍니다.
            """,
            leftButtonText: "취소",
            rightButtonText: "해제"
        )
    }

    static var withdraw: Self {
        return .init(
            image: .Icon.Illustration.modalWarning,
            title: "정말 탈퇴하시겠어요?",
            subtitle: """
            커플 연결이 끊어집니다.
            데이터는 전부 삭제되며 복구가 불가능합니다.
            """,
            leftButtonText: "취소",
            rightButtonText: "탈퇴"
        )
    }

    // MARK: - 온보딩 알림 권한

    static var notificationMarketing: Self {
        return .init(
            image: .Icon.Illustration.heart,
            title: "마케팅 알림을 허용하시겠어요?",
            subtitle: """
            키피럽의 새로운 소식과
            이벤트 정보를 받아볼 수 있어요
            """,
            leftButtonText: "거부",
            rightButtonText: "허용"
        )
    }

    static var notificationNight: Self {
        return .init(
            image: .Icon.Illustration.heart,
            title: "야간 알림을 허용하시겠어요?",
            subtitle: """
            밤 9시 ~ 아침 8시 사이에도
            마케팅 알림을 받아볼 수 있어요
            """,
            leftButtonText: "거부",
            rightButtonText: "허용"
        )
    }
}
