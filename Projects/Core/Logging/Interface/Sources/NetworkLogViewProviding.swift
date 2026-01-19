//
//  NetworkLogViewProviding.swift
//  CoreLoggingInterface
//
//  Created by Jiyong
//

import SwiftUI

#if DEBUG
import Pulse
#endif

/// 네트워크 로그 화면을 제공하는 프로토콜입니다.
///
/// ## 사용 예시
/// ```swift
/// let view = await provider.makePulseLogView(label: "Home")
/// ```
public protocol NetworkLogViewProviding {
    /// Pulse 네트워크 로그 화면을 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let view = await provider.makePulseLogView(label: "Auth")
    /// ```
    @MainActor
    func makePulseLogView(label: String) -> AnyView
}
