//
//  View+Typography.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/13/26.
//

import SwiftUI

public extension View {
    /// 디자인 시스템에 정의된 Typography를 적용합니다.
    /// - Parameter token: font, size, 행간, 자간을 정의한 `TypographyToken`입니다.
    /// - Returns: Typography가 적용된 `View`
    func typography(_ token: TypographyToken) -> some View {
        self
            .padding(.vertical, token.lineSpacing / 2)
            .font(token.font.swiftUIFont(size: token.size))
            .lineSpacing(token.lineSpacing)
            .kerning(token.kerning)
    }
}
