//
//  TXToastPresenter.swift
//  SharedDesignSystem
//
//  Created by 정지용 on 1/22/26.
//

import SwiftUI

/// Toast 메시지를 표시하기 위한 Presenter입니다.
///
/// TXToastPresenter는 Content 위에 토스트를 오버레이하여 표시합니다.
/// 위치, 3초 뒤 자동 dismiss, 애니메이션을 지원합니다.
///
/// ## 사용 예시
/// ```swift
/// struct ContentView: View {
///     @State private var showToast = false
///
///     var body: some View {
///         TXToastPresenter(
///             isPresented: $showToast,
///             message: "목표를 달성했어요"
///         ) {
///             // 실제 콘텐츠
///             VStack {
///                 Button("토스트 보기") {
///                     showToast = true
///                 }
///             }
///         }
///     }
/// }
///
/// // 버튼이 있는 토스트
/// TXToastPresenter(
///     isPresented: $showToast,
///     message: "목표를 달성했어요",
///     showButton: true,
///     onButtonTap: { /* 액션 */ }
/// ) {
///     ContentView()
/// }
///
/// // 상단에 표시하는 토스트
/// TXToastPresenter(
///     isPresented: $showToast,
///     message: "알림이 도착했어요",
///     position: .top
/// ) {
///     ContentView()
/// }
///
/// // 수동 dismiss (자동 dismiss 비활성화)
/// TXToastPresenter(
///     isPresented: $showToast,
///     message: "확인 버튼을 눌러주세요",
///     duration: nil
/// ) {
///     ContentView()
/// }
/// ```
public struct TXToastPresenter<Content: View>: View {
    @Binding private var isPresented: Bool
    private let icon: Image
    private let message: String
    private let showButton: Bool
    private let onButtonTap: (() -> Void)?
    private let position: Position
    private let duration: TimeInterval?
    private let content: () -> Content

    @State private var dragOffset: CGFloat = 0

    public enum Position {
        case top
        case bottom
    }

    public init(
        isPresented: Binding<Bool>,
        icon: Image = Image.Icon.Illustration.success,
        message: String,
        showButton: Bool = false,
        onButtonTap: (() -> Void)? = nil,
        position: Position = .bottom,
        duration: TimeInterval? = 3.0,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._isPresented = isPresented
        self.icon = icon
        self.message = message
        self.showButton = showButton
        self.onButtonTap = onButtonTap
        self.position = position
        self.duration = duration
        self.content = content
    }

    public var body: some View {
        content()
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
private extension TXToastPresenter {
    var toastView: some View {
        TXToast(
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

    var swipeToDismissGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                let translation = value.translation.height
                // position에 따라 허용되는 드래그 방향 제한
                if position == .bottom {
                    // 아래로만 드래그 허용
                    dragOffset = max(0, translation)
                } else {
                    // 위로만 드래그 허용
                    dragOffset = min(0, translation)
                }
            }
            .onEnded { value in
                let threshold: CGFloat = Constants.swipeThreshold
                let translation = value.translation.height

                if (position == .bottom && translation > threshold) ||
                    (position == .top && translation < -threshold) {
                    // dismiss
                    isPresented = false
                }
                // 원위치로 복귀
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
private extension TXToastPresenter {
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
private extension TXToastPresenter {
    enum Constants {
        static var horizontalPadding: CGFloat { 16 }
        static var edgePadding: CGFloat { 16 }
        static var swipeThreshold: CGFloat { 50 }
    }
}

// MARK: - Preview
#Preview("Bottom Position") {
    struct PreviewWrapper: View {
        @State private var showToast = true

        var body: some View {
            TXToastPresenter(
                isPresented: $showToast,
                message: "목표를 달성했어요",
                showButton: true,
                onButtonTap: { print("Button tapped") }
            ) {
                ZStack {
                    Color.gray.opacity(0.3)
                    Button("Toggle Toast") {
                        showToast.toggle()
                    }
                }
            }
        }
    }

    return PreviewWrapper()
}

#Preview("Top Position") {
    struct PreviewWrapper: View {
        @State private var showToast = true

        var body: some View {
            TXToastPresenter(
                isPresented: $showToast,
                message: "알림이 도착했어요",
                position: .top
            ) {
                ZStack {
                    Color.gray.opacity(0.3)
                    Button("Toggle Toast") {
                        showToast.toggle()
                    }
                }
            }
        }
    }

    return PreviewWrapper()
}

#Preview("No Auto Dismiss") {
    struct PreviewWrapper: View {
        @State private var showToast = true

        var body: some View {
            TXToastPresenter(
                isPresented: $showToast,
                message: "수동으로 닫아주세요",
                showButton: true,
                onButtonTap: { },
                duration: nil
            ) {
                ZStack {
                    Color.gray.opacity(0.3)
                    Button("Toggle Toast") {
                        showToast.toggle()
                    }
                }
            }
        }
    }

    return PreviewWrapper()
}
