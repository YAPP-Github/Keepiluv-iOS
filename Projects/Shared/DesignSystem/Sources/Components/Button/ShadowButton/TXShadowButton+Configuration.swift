//
//  TXShadowButton+Configuration.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/25/26.
//

import SwiftUI

public extension TXShadowButton.Configuration {
    /// 중간 너비(150x68) 버튼 설정을 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let config = TXShadowButton.Configuration.medium(text: "업로드하기")
    /// ```
    static func medium(
        text: String
    ) -> Self {
        .init(
            text: text,
            style: .medium
        )
    }
    
    /// 가로 전체 너비(높이 68) 버튼 설정을 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let config = TXShadowButton.Configuration.long(text: "업로드하기")
    /// ```
    static func long(
        text: String
    ) -> Self {
        .init(
            text: text,
            style: .long
        )
    }
}
