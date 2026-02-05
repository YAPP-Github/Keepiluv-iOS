//
//  TXRoundedRectangleGroupButton+Configuration.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/20/26.
//

import SwiftUI

public extension TXRoundedRectangleGroupButton.Configuration {
    /// 모달 버튼 그룹 구성을 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let config = TXRoundedRectangleGroupButton.Configuration.modal(
    ///     leftText: "취소",
    ///     rightText: "삭제"
    /// )
    /// ```
    static func modal(
        leftText: String,
        rightText: String,
        leftColorStyle: ColorStyle = .white,
        rightColorStyle: ColorStyle = .black
    ) -> Self {
        .init(
            leftText: leftText,
            rightText: rightText,
            leftColorStyle: leftColorStyle,
            rightColorStyle: rightColorStyle
        )
    }
}
