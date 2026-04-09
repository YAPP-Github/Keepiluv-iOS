//
//  TXModalView.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/18/26.
//

import SwiftUI

/// `TXModalStyle`에 따라 콘텐츠와 버튼을 구성하는 모달 컨테이너입니다.
///
/// `TXModalView`는 외부에서 별도 content를 주입받지 않고, style case를 기준으로
/// 정보형 모달, 아이콘 선택형 모달, 리스트 선택형 모달 콘텐츠를 내부에서 생성합니다.
///
/// ## 사용 예시
/// ```swift
/// TXModalView(
///     style: .info(
///         image: .Icon.Illustration.modalWarning,
///         title: "체크를 해제할까요?",
///         subtitle: "해제하면 등록한 사진은 사라집니다.",
///         leftButtonText: "취소",
///         rightButtonText: "해제"
///     ),
///     selectedIndex: .constant(0),
///     onAction: { action in
///         // handle action
///     }
/// )
/// ```
struct TXModalView: View {
    private let style: TXModalStyle
    @Binding private var selectedIndex: Int
    private let onAction: (TXModalAction) -> Void

    init(
        style: TXModalStyle,
        selectedIndex: Binding<Int>,
        onAction: @escaping (TXModalAction) -> Void
    ) {
        self.style = style
        self._selectedIndex = selectedIndex
        self.onAction = onAction
    }

    var body: some View {
        ZStack {
            dimBackground
            
            VStack(spacing: Constants.rootVStackSpacing) {
                modalContent
                actionButtons
            }
            .frame(width: Constants.width)
            .background(Constants.backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: Constants.radius))
        }
    }
}

// MARK: - Constants
private enum Constants {
    static let rootVStackSpacing: CGFloat = 0
    static let width: CGFloat = 350
    static let backgroundColor: Color = Color.Common.white
    static let radius: CGFloat = 20
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
    var modalContent: some View {
        switch style {
        case let .info(image, title, subtitle, _, _):
            TXInfoModalContent(
                image: image,
                title: title,
                subtitle: subtitle
            )
            
        case let .selection(title, icons, _, _):
            TXSelectionModalContent(
                title: title,
                icons: icons,
                selectedIndex: $selectedIndex
            )

        case let .selectList(title, subtitle, options, _, _, _):
            TXSelectListContent(
                title: title,
                subtitle: subtitle,
                options: options,
                selectedIndex: $selectedIndex
            )
        }
    }
    
    @ViewBuilder
    var actionButtons: some View {
        Group {
            switch style {
            case let .info(_, _, _, leftButtonText, rightButtonText):
                infoActionButtons(
                    leftButtonText: leftButtonText,
                    rightButtonText: rightButtonText
                )
                
            case let .selection(_, _, _, buttonTitle):
                singleActionButton(title: buttonTitle)

            case let .selectList(_, _, _, _, leftButtonText, rightButtonText):
                infoActionButtons(
                    leftButtonText: leftButtonText,
                    rightButtonText: rightButtonText
                )
            }
        }
        .padding(.bottom, Spacing.spacing6)
    }
    
    func infoActionButtons(leftButtonText: String, rightButtonText: String) -> some View {
        HStack(spacing: Spacing.spacing5) {
            TXButton(
                shape: .rect(
                    style: .basic(text: leftButtonText),
                    size: .m,
                    state: .line
                ),
                onTap: { onAction(.cancel) }
            )
            
            TXButton(
                shape: .rect(
                    style: .basic(text: rightButtonText),
                    size: .m,
                    state: .standard
                ),
                onTap: { onAction(.confirm) }
            )
        }
        .padding(.vertical, Spacing.spacing5)
        .padding(.horizontal, Spacing.spacing8)
        .padding(.top, Spacing.spacing6)
    }
    
    func singleActionButton(title: String) -> some View {
        TXButton(
            shape: .rect(
                style: .basic(text: title),
                size: .l,
                state: .standard
            ),
            onTap: { onAction(.confirm) }
        )
        .padding([.horizontal, .top], Spacing.spacing8)
    }
}
