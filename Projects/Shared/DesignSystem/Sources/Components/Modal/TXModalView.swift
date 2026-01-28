//
//  TXModalView.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/18/26.
//

import SwiftUI

/// 딤 처리된 배경 위에 표시되는 모달 뷰입니다.
///
/// ## 사용 예시
/// ```swift
/// TXModalView(
///     config: .confirm(
///         image: .Icon.Symbol.drug
///         title: "제목",
///         subTitle: "설명",
///         onConfirm: { }
///     ),
///     onDismiss: { }
/// )
/// ```
public struct TXModalView: View {
    /// 모달의 이미지/텍스트/액션 구성을 정의하는 설정 타입입니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let config = TXModalView.Configuration(
    ///     image: .Icon.Illustration.drug,
    ///     title: "제목",
    ///     subTitle: "설명",
    ///     imageSize: .init(width: 120, height: 120),
    ///     imageFrameSize: .init(width: 160, height: 160),
    ///     onConfirm: { }
    /// )
    /// ```
    public struct Configuration {
        public let image: Image
        public let title: String
        public let subTitle: String
        public let imageSize: CGSize
        public let imageFrameSize: CGSize
        public let onConfirm: () -> Void

        /// 모달 구성 값을 생성합니다.
        ///
        /// ## 사용 예시
        /// ```swift
        /// let config = TXModalView.Configuration(
        ///     image: .Icon.Illustration.drug,
        ///     title: "제목",
        ///     subTitle: "설명",
        ///     imageSize: .init(width: 120, height: 120),
        ///     imageFrameSize: .init(width: 160, height: 160),
        ///     onConfirm: { }
        /// )
        /// ```
        public init(
            image: Image,
            title: String,
            subTitle: String,
            imageSize: CGSize,
            imageFrameSize: CGSize,
            onConfirm: @escaping () -> Void
        ) {
            self.image = image
            self.title = title
            self.subTitle = subTitle
            self.onConfirm = onConfirm
            self.imageSize = imageSize
            self.imageFrameSize = imageFrameSize
        }
    }
    
    private let config: Configuration
    private let onDismiss: () -> Void
    
    /// TXModalView를 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// TXModalView(
    ///     config: config,
    ///     onDismiss: { }
    /// )
    /// ```
    public init(
        config: Configuration,
        onDismiss: @escaping () -> Void
    ) {
        self.config = config
        self.onDismiss = onDismiss
    }
    
    public var body: some View {
        ZStack {
            dimBackground
            
            VStack(spacing: 0) {
                modalImage
                titleText
                subtitleText
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
                onDismiss()
            }
    }

    var modalImage: some View {
        config.image
            .padding(.top, Spacing.spacing8)
    }

    var titleText: some View {
        Text(config.title)
            .typography(.t1_18eb)
            .multilineTextAlignment(.center)
            .padding(.top, Spacing.spacing7)
    }

    var subtitleText: some View {
        Text(config.subTitle)
            .typography(.b2_14r)
            .padding(.top, Spacing.spacing6)
    }

    var actionButtons: some View {
        TXRoundedRectangleGroupButton(
            config: .modal(),
            actionLeft: {
                onDismiss()
            },
            actionRight: {
                config.onConfirm()
            }
        )
        .padding(.top, Spacing.spacing9)
        .padding(.bottom, Spacing.spacing6)
    }
}

#Preview {
    VStack {
        TXModalView(
            config: .deleteGoal(
                image: .Icon.Illustration.drug,
                title: "매일 비타민 먹기\n목표를 이루셨나요?",
                onConfirm: { }
            ),
            onDismiss: { }
        )
    }
}
