//
//  TXLoadingPresenter.swift
//  SharedDesignSystem
//
//  Created by 정지용 on 5/5/26.
//

import SwiftUI

// MARK: - TXLoadingModifier

/// 로딩 상태를 표시하는 ViewModifier입니다.
/// - message가 nil이면 스피너 단독 + dimmed20
/// - message가 있으면 중앙 캡슐 + dimmed70
struct TXLoadingModifier: ViewModifier {
    let isPresented: Bool
    let message: String?

    private var dimColor: Color {
        message == nil ? Color.Dimmed.dimmed20 : Color.Dimmed.dimmed70
    }

    func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(isPresented)
            if isPresented {
                dimColor
                    .ignoresSafeArea()
                if let message {
                    TXLoadingStatusView(message: message)
                } else {
                    TXLoadingIndicator()
                }
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isPresented)
    }
}

// MARK: - View Extension
public extension View {
    /// 스피너를 dimmed20 배경과 함께 표시합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// VStack { ... }
    ///     .txLoading(isPresented: store.isLoading)
    /// ```
    func txLoading(isPresented: Bool) -> some View {
        self.modifier(TXLoadingModifier(isPresented: isPresented, message: nil))
    }

    /// 중앙 캡슐 로딩 뷰를 `String?` item 기반으로 표시합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// VStack { ... }
    ///     .txLoading(item: store.loadingMessage)
    /// ```
    func txLoading(item: String?) -> some View {
        self.modifier(TXLoadingModifier(isPresented: item != nil, message: item))
    }
}

// MARK: - Preview
#Preview("스피너 only") {
    struct PreviewWrapper: View {
        @State private var isLoading = false

        var body: some View {
            Button("토글") { isLoading.toggle() }
                .txLoading(isPresented: isLoading)
        }
    }

    return PreviewWrapper()
}

#Preview("캡슐 - item") {
    struct PreviewWrapper: View {
        @State private var loadingMessage: String?

        var body: some View {
            VStack(spacing: 16) {
                Button("업로드") { loadingMessage = "업로드 중..." }
                Button("저장") { loadingMessage = "저장 중..." }
                Button("숨기기") { loadingMessage = nil }
            }
            .txLoading(item: loadingMessage)
        }
    }

    return PreviewWrapper()
}
