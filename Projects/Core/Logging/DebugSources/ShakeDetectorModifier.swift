//
//  ShakeDetectorModifier.swift
//  CoreLoggingDebug
//
//  Created by Jiyong
//

import SwiftUI
import UIKit

/// Shake 제스처 감지 시 Pulse UI를 표시하는 ViewModifier
///
/// UIWindow extension이 shake를 자동으로 감지하므로
/// 별도의 overlay 없이 NotificationCenter를 통해 이벤트를 수신합니다.
struct ShakeDetectorModifier: ViewModifier {
    let label: String
    @State private var isShowingPulse = false

    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isShowingPulse) {
                PulseNetworkLogViewProvider().makePulseLogView(label: label)
            }
            .onReceive(NotificationCenter.default.publisher(for: .deviceDidShake)) { _ in
                isShowingPulse = true
            }
    }
}

/// Deprecated: UIWindow extension이 shake를 자동으로 감지합니다.
@available(*, deprecated, message: "UIWindow extension handles shake detection automatically")
struct ShakeDetectingHostingView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ShakeDetectingHostingController {
        ShakeDetectingHostingController()
    }

    func updateUIViewController(_ uiViewController: ShakeDetectingHostingController, context: Context) {}
}

/// Deprecated: UIWindow extension이 shake를 자동으로 감지합니다.
@available(*, deprecated, message: "UIWindow extension handles shake detection automatically")
struct ShakeDetectingView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ShakeDetectingViewController {
        ShakeDetectingViewController()
    }

    func updateUIViewController(_ uiViewController: ShakeDetectingViewController, context: Context) {}
}

public extension View {
    /// Shake 제스처로 Pulse 로그 UI를 표시하도록 설정합니다.
    ///
    /// 디바이스를 흔들면 특정 label 로그를 볼 수 있는 Pulse UI가 표시됩니다.
    /// CoreLoggingDebug 모듈에서만 사용 가능합니다.
    ///
    /// - Returns: Shake 감지가 적용된 View
    ///
    /// 사용 예시:
    /// ```swift
    /// var body: some View {
    ///     ContentView()
    ///         .detectShakeForPulse()
    /// }
    /// ```
    func detectShakeForPulse(label: String = "Global") -> some View {
        modifier(ShakeDetectorModifier(label: label))
    }
}
