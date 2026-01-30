//
//  KeyboardFrameObserver.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/30/26.
//

import SwiftUI
import UIKit

private struct KeyboardFrameObserver: ViewModifier {
    @Binding var frame: CGRect

    func body(content: Content) -> some View {
        content
            .onAppear {
                let screenHeight = UIScreen.main.bounds.height
                let hiddenFrame = CGRect(x: 0, y: screenHeight, width: 0, height: 0)
                if frame == .zero {
                    frame = hiddenFrame
                }
            }
            .onReceive(
                NotificationCenter.default.publisher(
                    for: UIResponder.keyboardWillChangeFrameNotification
                )
            ) { notification in
                guard
                    let frame = notification.userInfo?[
                        UIResponder.keyboardFrameEndUserInfoKey
                    ] as? CGRect
                else { return }
                if frame != self.frame {
                    self.frame = frame
                }
            }
            .onReceive(
                NotificationCenter.default.publisher(
                    for: UIResponder.keyboardWillHideNotification
                )
            ) { _ in
                let screenHeight = UIScreen.main.bounds.height
                let hiddenFrame = CGRect(x: 0, y: screenHeight, width: 0, height: 0)
                if frame != hiddenFrame {
                    frame = hiddenFrame
                }
            }
    }
}

public extension View {
    /// 키보드 프레임 변화를 관찰해 `frame` 바인딩에 반영합니다.
    ///
    /// - Parameter frame: 키보드의 마지막 프레임을 저장할 바인딩 값.
    ///   키보드가 숨겨졌을 때는 화면 아래로 내려간 프레임이 들어갑니다.
    /// - Returns: 키보드 프레임을 관찰하는 뷰.
    ///
    /// ## 사용 예시
    /// ```swift
    /// @State private var keyboardFrame: CGRect = .zero
    ///
    /// VStack { ... }
    ///     .observeKeyboardFrame($keyboardFrame)
    /// ```
    func observeKeyboardFrame(_ frame: Binding<CGRect>) -> some View {
        modifier(KeyboardFrameObserver(frame: frame))
    }
}
