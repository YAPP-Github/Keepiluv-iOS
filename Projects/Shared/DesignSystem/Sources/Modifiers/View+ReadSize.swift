//
//  View+ReadSize.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/30/26.
//

import SwiftUI

private struct CGSizePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) { value = nextValue() }
}

public extension View {
    /// 뷰의 프레임을 읽어 `onChange`로 전달합니다.
    ///
    /// - Parameter onChange: 프레임이 변경될 때마다 호출되는 클로저.
    ///   `CGRect`는 `.global` 좌표계를 기준으로 합니다.
    /// - Returns: 프레임을 관찰하는 뷰.
    ///
    /// - Warning: 레이아웃 패스마다 호출될 수 있으므로, 클로저 안에서
    ///   무거운 연산이나 무한 업데이트가 발생하지 않도록 주의하세요.
    ///   필요하면 값 변화 비교 후 상태를 갱신하세요.
    ///
    /// ## 사용 예시
    /// ```swift
    /// @State private var rectFrame: CGRect = .zero
    ///
    /// MyView()
    ///     .readSize { rectFrame = $0 }
    /// ```
    func readSize(_ onChange: @escaping (CGRect) -> Void) -> some View {
        background(
            GeometryReader { geo in
                Color.clear.preference(key: CGSizePreferenceKey.self, value: geo.frame(in: .global))
            }
        )
        .onPreferenceChange(CGSizePreferenceKey.self, perform: onChange)
    }
}
