//
//  TXModalView.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/18/26.
//

import SwiftUI

/// 딤 처리된 배경 위에 표시되는 모달 컨테이너입니다.
public struct TXModalView<Content: View>: View {
    private let type: TXModalType
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
        type: TXModalType,
        @ViewBuilder content: () -> Content,
        onAction: @escaping (TXModalAction) -> Void,
    ) {
        self.type = type
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
            .frame(width: 350)
            .background(Color.Common.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
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

    @ViewBuilder
    var actionButtons: some View {
        Group {
            switch type {
            case .info:
                TXRoundedRectangleGroupButton(
                    config: .modal(),
                    actionLeft: {
                        onAction(.cancel)
                    },
                    actionRight: {
                        onAction(.confirm)
                    }
                )
                
            case let .gridButton(config):
                TXRoundedRectangleButton(
                    config: .long(
                        text: config.buttonTitle,
                        colorStyle: .black
                    )
                ) {
                    onAction(.confirm)
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.top, Spacing.spacing9)
        .padding(.bottom, Spacing.spacing6)
    }
}

#Preview {
    VStack {
        TXModalView(type: .info(.deleteGoal)) {
            TXInfoModalContent(config: .deleteGoal)
        } onAction: { _ in
            
        }
    }
}
