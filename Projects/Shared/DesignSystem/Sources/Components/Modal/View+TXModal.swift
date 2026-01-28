//
//  View+TXModal.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/27/26.
//

import SwiftUI

public struct TXModalModifier: ViewModifier {
    @Binding private var item: TXModalType?
    private let onConfirm: () -> Void

    public init(
        item: Binding<TXModalType?>,
        onConfirm: @escaping () -> Void
    ) {
        self._item = item
        self.onConfirm = onConfirm
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
                    config: item.configuration(onConfirm: onConfirm)
                )
                .transition(.opacity)
                .zIndex(1)
            }
        }
        .animation(.easeInOut, value: isPresented.wrappedValue)
    }
}

public extension View {
    /// TXModalType 기반으로 TXModalView를 표시하는 modifier입니다.
    func txModal(
        item: Binding<TXModalType?>,
        onConfirm: @escaping () -> Void
    ) -> some View {
        modifier(TXModalModifier(item: item, onConfirm: onConfirm))
    }
}
