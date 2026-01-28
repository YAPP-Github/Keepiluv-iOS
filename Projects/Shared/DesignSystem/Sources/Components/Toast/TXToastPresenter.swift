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
    let icon: Image
    let message: String
    let showButton: Bool
    let onButtonTap: (() -> Void)?
    let position: TXToastPosition
    let duration: TimeInterval?

    @State private var dragOffset: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: position == .top ? .top : .bottom) {
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
            .padding(position == .top ? .top : .bottom, Constants.edgePadding)
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
            .padding(position == .top ? .top : .bottom, Constants.edgePadding)
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
    /// 토스트 메시지를 표시합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// struct ContentView: View {
    ///     @State private var showToast = false
    ///
    ///     var body: some View {
    ///         VStack {
    ///             Button("토스트 보기") {
    ///                 showToast = true
    ///             }
    ///         }
    ///         .txToast(
    ///             isPresented: $showToast,
    ///             message: "목표를 달성했어요"
    ///         )
    ///     }
    /// }
    ///
    /// // 버튼이 있는 토스트
    /// ContentView()
    ///     .txToast(
    ///         isPresented: $showToast,
    ///         message: "목표를 달성했어요",
    ///         showButton: true,
    ///         onButtonTap: { /* 액션 */ }
    ///     )
    ///
    /// // fit 스타일 토스트 (텍스트 크기에 맞춤)
    /// ContentView()
    ///     .txToast(
    ///         isPresented: $showToast,
    ///         style: .fit,
    ///         message: "2자에서 8자 이내로 닉네임을 입력해주세요."
    ///     )
    ///
    /// // 수동 dismiss (자동 dismiss 비활성화)
    /// ContentView()
    ///     .txToast(
    ///         isPresented: $showToast,
    ///         message: "확인 버튼을 눌러주세요",
    ///         duration: nil
    ///     )
    /// ```
    ///
    /// - Parameters:
    ///   - isPresented: 토스트 표시 여부를 제어하는 Binding입니다.
    ///   - style: 토스트 스타일입니다. 기본값은 .fixed입니다.
    ///   - icon: 토스트에 표시될 아이콘입니다. 기본값은 성공 아이콘입니다. (fixed 스타일만)
    ///   - message: 토스트에 표시될 메시지입니다.
    ///   - showButton: 버튼 표시 여부입니다. 기본값은 false입니다. (fixed 스타일만)
    ///   - onButtonTap: 버튼 탭 시 실행될 클로저입니다.
    ///   - position: 토스트가 표시될 위치입니다. 기본값은 .bottom입니다.
    ///   - duration: 자동 dismiss까지의 시간입니다. nil 설정 시 수동 dismiss만 가능합니다. 기본값은 3초입니다.
    func txToast(
        isPresented: Binding<Bool>,
        style: TXToastStyle = .fixed,
        icon: Image = Image.Icon.Illustration.success,
        message: String,
        showButton: Bool = false,
        onButtonTap: (() -> Void)? = nil,
        position: TXToastPosition = .bottom,
        duration: TimeInterval? = 3.0
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
                duration: duration
            )
        )
    }
}

// MARK: - Preview
#Preview("Bottom Position") {
    struct PreviewWrapper: View {
        @State private var showToast = true

        var body: some View {
            ZStack {
                Color.gray.opacity(0.3)
                Button("Toggle Toast") {
                    showToast.toggle()
                }
            }
            .txToast(
                isPresented: $showToast,
                message: "목표를 달성했어요",
                showButton: true,
                onButtonTap: { print("Button tapped") }
            )
        }
    }

    return PreviewWrapper()
}

#Preview("Top Position") {
    struct PreviewWrapper: View {
        @State private var showToast = true

        var body: some View {
            ZStack {
                Color.gray.opacity(0.3)
                Button("Toggle Toast") {
                    showToast.toggle()
                }
            }
            .txToast(
                isPresented: $showToast,
                message: "알림이 도착했어요",
                position: .top
            )
        }
    }

    return PreviewWrapper()
}

#Preview("No Auto Dismiss") {
    struct PreviewWrapper: View {
        @State private var showToast = true

        var body: some View {
            ZStack {
                Color.gray.opacity(0.3)
                Button("Toggle Toast") {
                    showToast.toggle()
                }
            }
            .txToast(
                isPresented: $showToast,
                message: "수동으로 닫아주세요",
                showButton: true,
                onButtonTap: { },
                duration: nil
            )
        }
    }

    return PreviewWrapper()
}

#Preview("Fit Style") {
    struct PreviewWrapper: View {
        @State private var showToast = true

        var body: some View {
            ZStack {
                Color.gray.opacity(0.3)
                Button("Toggle Toast") {
                    showToast.toggle()
                }
            }
            .txToast(
                isPresented: $showToast,
                style: .fit,
                message: "2자에서 8자 이내로 닉네임을 입력해주세요."
            )
        }
    }

    return PreviewWrapper()
}
