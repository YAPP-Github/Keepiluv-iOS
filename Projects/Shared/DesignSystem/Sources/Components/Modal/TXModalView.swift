//
//  TXModalView.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/18/26.
//

import SwiftUI

/// 딤 처리된 배경 위에 표시되는 모달 컨테이너입니다.
public struct TXModalView<Content: View>: View {
    private let content: Content
    private let onAction: (TXModalAction) -> Void

    /// 모달 컨테이너를 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// TXModalView(
    ///     content: {
    ///         TXInfoModalContent(config: .deleteGoal)
    ///     },
    ///     onAction: { action in
    ///         if action == .confirm {
    ///             // handle confirm
    ///         }
    ///     }
    /// )
    /// ```
    public init(
        @ViewBuilder content: () -> Content,
        onAction: @escaping (TXModalAction) -> Void
    ) {
        self.content = content()
        self.onAction = onAction
    }

    public var body: some View {
        ZStack {
            dimBackground

            VStack(spacing: 0) {
                content
                actionButtons
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.white)
                    .frame(width: 350)
            )
        }
    }
}

// MARK: - SubViews
private extension TXModalView {
    var dimBackground: some View {
        Color.Dimmed.dimmed70
            .ignoresSafeArea()
            .onTapGesture {
                onAction(.cancel)
            }
    }

    var actionButtons: some View {
        TXRoundedRectangleGroupButton(
            config: .modal(),
            actionLeft: {
                onAction(.cancel)
            },
            actionRight: {
                onAction(.confirm)
            }
        )
        .padding(.top, Spacing.spacing9)
        .padding(.bottom, Spacing.spacing6)
    }
}

#Preview {
    VStack {
        TXModalView {
            TXInfoModalContent(
                config: .init(
                    image: .Icon.Illustration.warning,
                    title: "목표를 이루셨나요?",
                    subtitle: "목표를 완료해도 사진은 사라지지 않아요"
                )
            )
        } onAction: { _ in }
    }
}
