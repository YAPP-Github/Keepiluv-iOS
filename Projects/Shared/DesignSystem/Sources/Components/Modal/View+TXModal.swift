//
//  View+TXModal.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/27/26.
//

import SwiftUI

public struct TXModalModifier<Item: Identifiable>: ViewModifier {
    @Binding private var item: Item?
    private let config: (Item) -> TXModalView.Configuration

    public init(
        item: Binding<Item?>,
        config: @escaping (Item) -> TXModalView.Configuration
    ) {
        self._item = item
        self.config = config
    }

    private var isPresented: Binding<Bool> {
        Binding(
            get: { item != nil },
            set: { newValue in
                if !newValue { item = nil }
            }
        )
    }

    public func body(content: Content) -> some View {
        ZStack {
            content
            if let item {
                TXModalView(
                    isPresented: isPresented,
                    config: config(item)
                )
                .transition(.opacity)
                .zIndex(1)
            }
        }
        .animation(.easeInOut, value: isPresented.wrappedValue)
    }
}

public extension View {
    /// TXModalView를 item 기반으로 표시하는 modifier입니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// enum Modal: Identifiable {
    ///     case deleteGoal
    ///     var id: String { "deleteGoal" }
    /// }
    ///
    /// @State private var modal: Modal?
    ///
    /// Text("열기")
    ///     .txModal(item: $modal) { _ in
    ///         .deleteGoal(
    ///             image: .Icon.Illustration.drug,
    ///             title: "목표를 삭제할까요?",
    ///             onConfirm: { modal = nil }
    ///         )
    ///     }
    /// ```
    func txModal<Item: Identifiable>(
        item: Binding<Item?>,
        config: @escaping (Item) -> TXModalView.Configuration
    ) -> some View {
        modifier(TXModalModifier(item: item, config: config))
    }

    /// TXModalType 기반으로 TXModalView를 표시하는 modifier입니다.
    func txModal(
        item: Binding<TXModalType?>,
        onConfirm: @escaping () -> Void
    ) -> some View {
        txModal(item: item) { modal in
            modal.configuration(onConfirm: onConfirm)
        }
    }
}
