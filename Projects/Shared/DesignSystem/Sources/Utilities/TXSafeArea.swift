//
//  TXSafeArea.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 2/3/26.
//

import SwiftUI
import UIKit

/// 현재 활성 윈도우의 safe area 값을 조회하는 유틸리티입니다.
public enum TXSafeArea {
    /// 특정 edge의 safe area inset 값을 반환합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let bottomInset = TXSafeArea.inset(.bottom)
    /// ```
    public static func inset(_ edge: Edge) -> CGFloat {
        let insets = keyWindowInsets()

        switch edge {
        case .top: return insets.top
        case .leading: return insets.left
        case .bottom: return insets.bottom
        case .trailing: return insets.right
        }
    }

    private static func keyWindowInsets() -> UIEdgeInsets {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first(where: \.isKeyWindow)?
            .safeAreaInsets ?? .zero
    }
}
