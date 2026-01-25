//
//  TXShadowButton+Configuration.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/25/26.
//

import SwiftUI

public extension TXShadowButton.Configuration {
    /// 목표 상세 화면용 버튼 스타일을 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let config = TXShadowButton.Configuration.detailGoal(
    ///     text: "목표 미완료"
    /// )
    /// ```
    static func detailGoal(
        text: String,
    ) -> Self {
        .init(
            text: text,
            borderColor: Color.Gray.gray500,
        )
    }
    
    /// 인증샷 업로드 화면용 버튼 스타일을 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let config = TXShadowButton.Configuration.proofPhoto()
    /// ```
    static func proofPhoto() -> Self {
        .init(
            text: "업로드하기",
            borderColor: Color.Common.white,
        )
    }
}
