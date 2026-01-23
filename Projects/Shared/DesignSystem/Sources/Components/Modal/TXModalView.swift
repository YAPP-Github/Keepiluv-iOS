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
///     isPresented: $isPresented,
///     config: .confirm(
///         image: .Icon.Symbol.drug
///         title: "제목",
///         subTitle: "설명",
///         onConfirm: { }
///     )
/// )
/// ```
public struct TXModalView: View {
    public struct Configuration {
        public let image: Image
        public let title: String
        public let subTitle: String
        public let imageSize: CGSize
        public let imageFrameSize: CGSize
        public let onConfirm: () -> Void

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
    
    @Binding public var isPresented: Bool
    private let config: Configuration
    
    public init(
        isPresented: Binding<Bool>,
        config: Configuration
    ) {
        self._isPresented = isPresented
        self.config = config
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
                isPresented = false
            }
    }

    var modalImage: some View {
        config.image
            .resizable()
            .frame(width: config.imageSize.width, height: config.imageSize.height)
            .frame(width: config.imageFrameSize.width, height: config.imageFrameSize.height)
            .insideBorder(
                Color.Gray.gray100,
                shape: .circle,
                lineWidth: LineWidth.m
            )
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
                isPresented = false
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
            isPresented: .constant(true),
            config: .deleteGoal(
                image: .Icon.Illustration.drug,
                title: "매일 비타민 먹기\n목표를 이루셨나요?",
                onConfirm: { }
            )
        )
    }
}
