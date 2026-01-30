//
//  View+TXModal.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/27/26.
//

import SwiftUI

/// TXModalType 기반 모달 표시를 위한 ViewModifier입니다.
public struct TXModalModifier: ViewModifier {
    @State private var isVisible = false
    private let animationDuration: Double = 0.2
    
    @Binding private var item: TXModalType?
    private let onConfirm: () -> Void
    
    /// TXModalModifier를 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// Text("Hello")
    ///     .modifier(
    ///         TXModalModifier(
    ///             item: $modal,
    ///             onConfirm: { }
    ///         )
    ///     )
    /// ```
    public init(
        item: Binding<TXModalType?>,
        onConfirm: @escaping () -> Void
    ) {
        self._item = item
        self.onConfirm = onConfirm
    }

    public func body(content: Content) -> some View {
        content
            .fullScreenCover(item: $item) { item in
                TXModalView(
                    config: item.configuration(onConfirm: confirmAndDismiss),
                    onDismiss: startDismiss
                )
                .presentationBackground(.clear)
                .opacity(isVisible ? 1 : 0)
                .onAppear {
                    withAnimation(.easeInOut(duration: animationDuration)) {
                        isVisible = true
                    }
                }
            }
            .transaction { transaction in
                transaction.disablesAnimations = true
            }
    }
}

// MARK: - Private Methods
private extension TXModalModifier {
    private func confirmAndDismiss() {
        onConfirm()
        startDismiss()
    }

    private func startDismiss() {
        withAnimation(.easeInOut(duration: animationDuration)) {
            isVisible = false
        }
        
        Task { @MainActor in
            try await Task.sleep(for: .seconds(animationDuration))
            item = nil
        }
    }
}

public extension View {
    /// TXModalType 기반으로 TXModalView를 표시하는 modifier입니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// VStack { }
    ///     .txModal(item: $modal) {
    ///         // confirm action
    ///     }
    /// ```
    func txModal(
        item: Binding<TXModalType?>,
        onConfirm: @escaping () -> Void
    ) -> some View {
        modifier(TXModalModifier(item: item, onConfirm: onConfirm))
    }
}
