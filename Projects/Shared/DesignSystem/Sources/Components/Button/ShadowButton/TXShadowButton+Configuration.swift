//
//  TXShadowButton+Configuration.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/25/26.
//

import SwiftUI

public extension TXShadowButton.Configuration {
    static func detailGoal(
        text: String,
    ) -> Self {
        .init(
            text: text,
            borderColor: Color.Gray.gray500,
        )
    }
    
    static func proofPhoto() -> Self {
        .init(
            text: "업로드하기",
            borderColor: Color.Common.white,
        )
    }
}
