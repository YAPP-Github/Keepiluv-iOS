//
//  TXInfoModalContent+Configuration.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 2/4/26.
//

import Foundation

public extension TXInfoModalContent.Configuration {
    static var deleteGoal: Self {
        return .init(
            image: .Icon.Illustration.emoji2,
            title: "목표를 이루셨나요?",
            subtitle: "목표를 완료해도 사진은 사라지지 않아요"
        )
    }
}
