//
//  View+TXSelectionModal.swift
//  SharedDesignSystem
//
//  Created by Jiyong on 02/05/26.
//

import SwiftUI

/// TXSelectionModalView 표시를 위한 ViewModifier입니다.
public struct TXSelectionModalModifier<Option: Hashable>: ViewModifier {
    @State private var isVisible = false
    private let animationDuration: Double = 0.2

    @Binding private var isPresented: Bool
    private let title: String
    private let subtitle: String?
    private let options: [Option]
    private let optionLabel: (Option) -> String
    @Binding private var selectedOption: Option
    private let onConfirm: () -> Void

    /// TXSelectionModalModifier를 생성합니다.
    public init(
        isPresented: Binding<Bool>,
        title: String,
        subtitle: String?,
        options: [Option],
        optionLabel: @escaping (Option) -> String,
        selectedOption: Binding<Option>,
        onConfirm: @escaping () -> Void
    ) {
        self._isPresented = isPresented
        self.title = title
        self.subtitle = subtitle
        self.options = options
        self.optionLabel = optionLabel
        self._selectedOption = selectedOption
        self.onConfirm = onConfirm
    }

    public func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $isPresented) {
                TXSelectionModalView(
                    title: title,
                    subtitle: subtitle,
                    options: options,
                    optionLabel: optionLabel,
                    selectedOption: $selectedOption,
                    onCancel: startDismiss,
                    onConfirm: confirmAndDismiss
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

private extension TXSelectionModalModifier {
    func confirmAndDismiss() {
        onConfirm()
        startDismiss()
    }

    func startDismiss() {
        withAnimation(.easeInOut(duration: animationDuration)) {
            isVisible = false
        }

        Task { @MainActor in
            try? await Task.sleep(for: .seconds(animationDuration))
            isPresented = false
        }
    }
}

// MARK: - View Extension

public extension View {
    /// TXSelectionModalView를 표시하는 modifier입니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// VStack { }
    ///     .txSelectionModal(
    ///         isPresented: $showModal,
    ///         title: "언어 설정",
    ///         subtitle: "이미 앱 내에 저장된 언어는 변경되지 않아요",
    ///         options: Language.allCases,
    ///         optionLabel: { $0.displayName },
    ///         selectedOption: $selectedLanguage
    ///     ) {
    ///         // confirm action
    ///     }
    /// ```
    func txSelectionModal<Option: Hashable>(
        isPresented: Binding<Bool>,
        title: String,
        subtitle: String? = nil,
        options: [Option],
        optionLabel: @escaping (Option) -> String,
        selectedOption: Binding<Option>,
        onConfirm: @escaping () -> Void
    ) -> some View {
        modifier(
            TXSelectionModalModifier(
                isPresented: isPresented,
                title: title,
                subtitle: subtitle,
                options: options,
                optionLabel: optionLabel,
                selectedOption: selectedOption,
                onConfirm: onConfirm
            )
        )
    }

    /// String 옵션을 위한 TXSelectionModalView modifier입니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// VStack { }
    ///     .txSelectionModal(
    ///         isPresented: $showModal,
    ///         title: "언어 설정",
    ///         subtitle: "이미 앱 내에 저장된 언어는 변경되지 않아요",
    ///         options: ["한국어", "English", "日本語"],
    ///         selectedOption: $selectedLanguage
    ///     ) {
    ///         // confirm action
    ///     }
    /// ```
    func txSelectionModal(
        isPresented: Binding<Bool>,
        title: String,
        subtitle: String? = nil,
        options: [String],
        selectedOption: Binding<String>,
        onConfirm: @escaping () -> Void
    ) -> some View {
        modifier(
            TXSelectionModalModifier(
                isPresented: isPresented,
                title: title,
                subtitle: subtitle,
                options: options,
                optionLabel: { $0 },
                selectedOption: selectedOption,
                onConfirm: onConfirm
            )
        )
    }
}
