//
//  TXCalendarEnvironment.swift
//  SharedDesignSystem
//
//  Created by Claude on 1/26/26.
//

import SwiftUI

// MARK: - Picker Mode Exit Action

/// 캘린더 피커 모드 종료 액션을 나타내는 callable struct입니다.
public struct TXCalendarExitPickerModeAction {
    private let action: () -> Bool

    /// 액션을 생성합니다.
    /// - Parameter action: picker 모드였으면 `true`, 아니면 `false`를 반환하는 클로저
    ///
    /// ## 사용 예시
    /// ```swift
    /// let action = TXCalendarExitPickerModeAction {
    ///     true
    /// }
    /// ```
    public init(_ action: @escaping () -> Bool = { false }) {
        self.action = action
    }

    /// 액션을 실행합니다.
    /// - Returns: picker 모드였으면 `true`, 아니면 `false`
    ///
    /// ## 사용 예시
    /// ```swift
    /// let action = TXCalendarExitPickerModeAction { true }
    /// let didExit = action()
    /// ```
    public func callAsFunction() -> Bool {
        action()
    }
}

/// 캘린더 피커 모드 종료 액션을 전달하는 Environment Key입니다.
private struct TXCalendarExitPickerModeKey: EnvironmentKey {
    static let defaultValue = TXCalendarExitPickerModeAction()
}

public extension EnvironmentValues {
    /// 캘린더 피커 모드 종료 액션입니다.
    ///
    /// 커스텀 버튼에서 완료 액션 수행 전에 호출하세요.
    /// picker 모드였으면 `true`를 반환하고 모드를 종료합니다.
    /// picker 모드가 아니었으면 `false`를 반환합니다.
    ///
    /// ```swift
    /// @Environment(\.txCalendarExitPickerModeIfNeeded) var exitPickerMode
    ///
    /// Button("완료") {
    ///     if !exitPickerMode() {
    ///         // picker 모드가 아니었으므로 완료 처리
    ///         onComplete()
    ///     }
    /// }
    /// ```
    var txCalendarExitPickerModeIfNeeded: TXCalendarExitPickerModeAction {
        get { self[TXCalendarExitPickerModeKey.self] }
        set { self[TXCalendarExitPickerModeKey.self] = newValue }
    }
}
