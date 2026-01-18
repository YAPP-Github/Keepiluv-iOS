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
///     image: .Icon.Illustration.drug,
///     title: "제목",
///     subTitle: "설명",
///     onDelete: { }
/// )
/// ```
public struct TXModalView: View {
    
    @Binding public var isPresented: Bool
    
    private let image: Image
    private let title: String
    private let subTitle: String

    private let onDelete: () -> Void
    
    public init(
        isPresented: Binding<Bool>,
        image: Image,
        title: String,
        subTitle: String,
        onDelete: @escaping () -> Void
    ) {
        self._isPresented = isPresented
        self.image = image
        self.title = title
        self.subTitle = subTitle
        self.onDelete = onDelete
    }
    
    public var body: some View {
        ZStack {
            dimBackground
            modalContent
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

    var modalContent: some View {
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

    var modalImage: some View {
        image
            .resizable()
            .frame(width: 42, height: 42)
            .frame(width: 64, height: 64)
            .insideBorder(
                Color.Gray.gray100,
                shape: .circle,
                lineWidth: LineWidth.m
            )
            .padding(.top, Spacing.spacing8)
    }

    var titleText: some View {
        Text(title)
            .typography(.t1_18eb)
            .multilineTextAlignment(.center)
            .padding(.top, Spacing.spacing7)
    }

    var subtitleText: some View {
        Text(subTitle)
            .typography(.b2_14r)
            .padding(.top, Spacing.spacing6)
    }

    var actionButtons: some View {
        TXRoundedRectangleGroupButton(
            style: .plain(.modal),
            actionLeft: {
                isPresented = false
            },
            actionRight: {
                
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
            image: .Icon.Illustration.drug,
            title:
                     """
                     매일 비타민 먹기
                     목표를 이루셨나요?
                     """,
            subTitle: "목표를 완료해도 저장된 사진은 사라지지 않아요",
            onDelete: { }
        )
    }
}
