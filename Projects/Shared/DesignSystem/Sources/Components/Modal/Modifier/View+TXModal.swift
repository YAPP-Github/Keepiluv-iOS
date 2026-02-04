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
    private let onAction: (TXModalAction) -> Void
    
    /// TXModalModifier를 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// Text("Hello")
    ///     .modifier(
    ///         TXModalModifier(
    ///             item: $modal,
    ///             onAction: { _ in }
    ///         )
    ///     )
    /// ```
    public init(
        item: Binding<TXModalType?>,
        onAction: @escaping (TXModalAction) -> Void
    ) {
        self._item = item
        self.onAction = onAction
    }

    public func body(content: Content) -> some View {
        content
            .fullScreenCover(item: $item) { item in
                TXModalView(
                    content: {
                        modalContent(for: item)
                    },
                    onAction: handleAction
                )
                .presentationBackground {
                    Color.clear
                }
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
    @ViewBuilder
    func modalContent(for item: TXModalType) -> some View {
        switch item {
        case let .info(config):
            TXInfoModalContent(config: config)
        case .gridButton:
            
        }
    }

    func handleAction(_ action: TXModalAction) {
        onAction(action)
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
    ///     .txModal(item: $modal) { action in
    ///         // handle modal action
    ///     }
    /// ```
    func txModal(
        item: Binding<TXModalType?>,
        onAction: @escaping (TXModalAction) -> Void
    ) -> some View {
        modifier(TXModalModifier(item: item, onAction: onAction))
    }
}
