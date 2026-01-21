//
//  ShakeDetectorModifier.swift
//  CoreLogging
//
//  Created by Jiyong
//

#if DEBUG
import SwiftUI
import UIKit

/// Shake 제스처 감지 시 Pulse UI를 표시하는 ViewModifier
struct ShakeDetectorModifier: ViewModifier {
    let label: String
    @State private var isShowingPulse = false

    func body(content: Content) -> some View {
        content
            .overlay(
                ShakeDetectingHostingView()
                    .allowsHitTesting(false)
            )
            .sheet(isPresented: $isShowingPulse) {
                PulseNetworkLogViewProvider().makePulseLogView(label: label)
            }
            .onReceive(NotificationCenter.default.publisher(for: .deviceDidShake)) { _ in
                isShowingPulse = true
            }
    }
}

/// Shake를 감지하기 위한 투명한 HostingView
struct ShakeDetectingHostingView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ShakeDetectingHostingController {
        ShakeDetectingHostingController()
    }

    func updateUIViewController(_ uiViewController: ShakeDetectingHostingController, context: Context) {}
}

/// Deprecated: Use ShakeDetectorModifier directly
@available(*, deprecated, message: "Use ShakeDetectorModifier directly")
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
    /// DEBUG 빌드에서만 사용 가능합니다.
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
#endif
