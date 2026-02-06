//
//  TXGridButtonModal+Configuration.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 2/4/26.
//

import SwiftUI

public extension TXGridButtonModalContent.Configuration {
    /// 아이콘 선택용 그리드 모달 기본 구성을 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let config = TXGridButtonModalContent.Configuration.selectIcon(
    ///     icons: [.Icon.Illustration.book, .Icon.Illustration.exercise],
    ///     selectedIndex: 0
    /// )
    /// ```
    static func selectIcon(
        icons: [Image],
        selectedIndex: Int
    ) -> Self {
        .init(
            title: "아이콘 변경",
            icons: icons,
            selectedIndex: selectedIndex,
            buttonTitle: "완료",
            gridCount: 4,
            imageSize: CGSize(width: 36, height: 36),
            frameSize: CGSize(width: 64, height: 64)
        )
    }
}
