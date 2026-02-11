//
//  TXToastPresenter.swift
//  SharedDesignSystem
//
//  Created by 정지용 on 1/22/26.
//

import SwiftUI

/// 토스트가 표시될 위치입니다.
public enum TXToastPosition {
    /// 화면 상단에 표시합니다.
    case top
    /// 화면 하단에 표시합니다.
    case bottom
}

/// Toast 메시지를 표시하기 위한 ViewModifier입니다.
struct TXToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    let style: TXToastStyle
    let icon: Image?
    let message: String
    let showButton: Bool
    let onButtonTap: (() -> Void)?
    let position: TXToastPosition
    let duration: TimeInterval?
    let customPadding: CGFloat?

    @State private var dragOffset: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: position == .top ? .top : .bottom) {
                Group {
                    if isPresented {
                        toastView
                            .transition(toastTransition)
                            .onAppear {
                                scheduleAutoDismiss()
                            }
                    }
                }
                .animation(.spring(duration: 0.3), value: isPresented)
                .animation(.spring(duration: 0.2), value: dragOffset)
            }
    }
}

// MARK: - SubViews
private extension TXToastModifier {
    @ViewBuilder
    var toastView: some View {
        if style == .fit {
            TXToast(
                style: .fit,
                message: message
            )
            .frame(maxWidth: .infinity)
            .safeAreaPadding(.horizontal, Constants.fitHorizontalInset)
            .padding(position == .top ? .top : .bottom, customPadding ?? Constants.edgePadding)
            .offset(y: dragOffset)
            .gesture(swipeToDismissGesture)
        } else {
            TXToast(
                style: .fixed,
                icon: icon,
                message: message,
                showButton: showButton,
                onButtonTap: onButtonTap
            )
            .safeAreaPadding(.horizontal, Constants.horizontalPadding)
            .padding(position == .top ? .top : .bottom, customPadding ?? Constants.edgePadding)
            .offset(y: dragOffset)
            .gesture(swipeToDismissGesture)
        }
    }

    var swipeToDismissGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                let translation = value.translation.height
                if position == .bottom {
                    dragOffset = max(0, translation)
                } else {
                    dragOffset = min(0, translation)
                }
            }
            .onEnded { value in
                let threshold: CGFloat = Constants.swipeThreshold
                let translation = value.translation.height

                if (position == .bottom && translation > threshold) ||
                    (position == .top && translation < -threshold) {
                    isPresented = false
                }
                dragOffset = 0
            }
    }

    var toastTransition: AnyTransition {
        let edge: Edge = position == .top ? .top : .bottom
        return .asymmetric(
            insertion: .move(edge: edge).combined(with: .opacity),
            removal: .move(edge: edge).combined(with: .opacity)
        )
    }
}

// MARK: - Private Methods
private extension TXToastModifier {
    func scheduleAutoDismiss() {
        guard let duration else { return }

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            if isPresented {
                isPresented = false
            }
        }
    }
}

// MARK: - Constants
private extension TXToastModifier {
    enum Constants {
        static var horizontalPadding: CGFloat { 16 }
        static var fitHorizontalInset: CGFloat { 18 }
        static var edgePadding: CGFloat { 16 }
        static var swipeThreshold: CGFloat { 50 }
    }
}

// MARK: - View Extension
public extension View {
    /// TXToastType item 기반으로 토스트를 표시합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// struct ContentView: View {
    ///     @State private var toast: TXToastType?
    ///
    ///     var body: some View {
    ///         VStack {
    ///             Button("성공 토스트") {
    ///                 toast = .success(message: "목표를 달성했어요")
    ///             }
    ///             Button("경고 토스트") {
    ///                 toast = .warning(message: "주의가 필요해요")
    ///             }
    ///             Button("Fit 토스트") {
    ///                 toast = .fit(message: "2자에서 8자 이내로 입력해주세요")
    ///             }
    ///         }
    ///         .txToast(item: $toast)
    ///     }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - isPresented: 토스트 표시 여부를 제어하는 Binding입니다.
    ///   - style: 토스트 스타일입니다. 기본값은 .fixed입니다.
    ///   - icon: 토스트에 표시될 아이콘입니다. nil이면 아이콘 없이 표시됩니다. (fixed 스타일만)
    ///   - message: 토스트에 표시될 메시지입니다.
    ///   - showButton: 버튼 표시 여부입니다. 기본값은 false입니다. (fixed 스타일만)
    ///   - onButtonTap: 버튼 탭 시 실행될 클로저입니다.
    ///   - position: 토스트가 표시될 위치입니다. 기본값은 .bottom입니다.
    ///   - duration: 자동 dismiss까지의 시간입니다. nil 설정 시 수동 dismiss만 가능합니다. 기본값은 3초입니다.
    func txToast(
        isPresented: Binding<Bool>,
        style: TXToastStyle = .fixed,
        icon: Image? = nil,
        message: String,
        showButton: Bool = false,
        onButtonTap: (() -> Void)? = nil,
        position: TXToastPosition = .bottom,
        duration: TimeInterval? = 3.0,
        customPadding: CGFloat? = nil
    ) -> some View {
        self.modifier(
            TXToastModifier(
                isPresented: isPresented,
                style: style,
                icon: icon,
                message: message,
                showButton: showButton,
                onButtonTap: onButtonTap,
                position: position,
                duration: duration,
                customPadding: customPadding
            )
        )
    }

    /// TXToastType item 기반으로 토스트를 표시합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// @State private var toast: TXToastType?
    ///
    /// VStack { }
    ///     .txToast(item: $toast)
    ///
    /// // 위치 오버라이드
    /// VStack { }
    ///     .txToast(item: $toast, position: .bottom, customPadding: 76)
    ///
    /// // 표시
    /// toast = .success(message: "목표를 달성했어요")
    /// ```
    ///
    /// - Parameters:
    ///   - item: 토스트 타입을 제어하는 Binding입니다. nil이 아닐 때 토스트가 표시됩니다.
    ///   - onButtonTap: 버튼 탭 시 실행될 클로저입니다.
    ///   - position: 토스트 위치를 오버라이드합니다. nil이면 TXToastType의 기본값을 사용합니다.
    ///   - customPadding: 토스트 edge padding을 오버라이드합니다.
    func txToast(
        item: Binding<TXToastType?>,
        onButtonTap: (() -> Void)? = nil,
        position: TXToastPosition? = nil,
        customPadding: CGFloat? = nil
    ) -> some View {
        let isPresented = Binding<Bool>(
            get: { item.wrappedValue != nil },
            set: { newValue in
                if !newValue { item.wrappedValue = nil }
            }
        )

        return self.modifier(
            TXToastModifier(
                isPresented: isPresented,
                style: item.wrappedValue?.style ?? .fixed,
                icon: item.wrappedValue?.icon,
                message: item.wrappedValue?.message ?? "",
                showButton: item.wrappedValue?.showButton ?? false,
                onButtonTap: onButtonTap,
                position: position ?? item.wrappedValue?.position ?? .bottom,
                duration: item.wrappedValue?.duration ?? 3.0,
                customPadding: customPadding
            )
        )
    }
}

// MARK: - Preview
#Preview("Success Toast") {
    struct PreviewWrapper: View {
        @State private var toast: TXToastType? = .success(message: "목표를 달성했어요")

        var body: some View {
            ZStack {
                Color.gray.opacity(0.3)
                Button("Toggle Toast") {
                    if toast == nil {
                        toast = .success(message: "목표를 달성했어요")
                    } else {
                        toast = nil
                    }
                }
            }
            .txToast(item: $toast) {
                print("Button tapped")
            }
        }
    }

    return PreviewWrapper()
}

#Preview("Fit Style") {
    struct PreviewWrapper: View {
        @State private var toast: TXToastType? = .fit(message: "2자에서 8자 이내로 닉네임을 입력해주세요.")

        var body: some View {
            ZStack {
                Color.gray.opacity(0.3)
                Button("Toggle Toast") {
                    if toast == nil {
                        toast = .fit(message: "2자에서 8자 이내로 닉네임을 입력해주세요.")
                    } else {
                        toast = nil
                    }
                }
            }
            .txToast(item: $toast)
        }
    }

    return PreviewWrapper()
}

#Preview("Warning Toast") {
    struct PreviewWrapper: View {
        @State private var toast: TXToastType? = .warning(message: "경고 메시지입니다")

        var body: some View {
            ZStack {
                Color.gray.opacity(0.3)
                Button("Toggle Toast") {
                    if toast == nil {
                        toast = .warning(message: "경고 메시지입니다")
                    } else {
                        toast = nil
                    }
                }
            }
            .txToast(item: $toast)
        }
    }

    return PreviewWrapper()
}
