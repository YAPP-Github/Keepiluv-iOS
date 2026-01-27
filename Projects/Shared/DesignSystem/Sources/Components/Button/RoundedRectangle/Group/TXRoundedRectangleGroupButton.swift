//
//  TXRoundedRectangleGroupButton.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/18/26.
//

import SwiftUI

/// 버튼 그룹 레이아웃 타입입니다.
public enum TXButtonGroupLayout {
    case modal
    case calendarSheet
}

/// 모달에서 사용하는 액션 버튼 그룹 컴포넌트입니다.
///
/// ## 사용 예시
/// ```swift
/// TXRoundedRectangleGroupButton(
///     config: .modal(),
///     actionLeft: {
///         print("cancel")
///     },
///     actionRight: {
///         print("delete")
///     }
/// )
/// ```
public struct TXRoundedRectangleGroupButton: View {
    public struct Configuration {
        let leftText: String
        let rightText: String
        let spacing: CGFloat = Spacing.spacing5
        let verticalPadding: CGFloat = Spacing.spacing5
        let horizontalPadding: CGFloat = Spacing.spacing8
        let leftColorStyle: ColorStyle
        let rightColorStyle: ColorStyle

        public init(
            leftText: String,
            rightText: String,
            leftColorStyle: ColorStyle,
            rightColorStyle: ColorStyle
        ) {
            self.leftText = leftText
            self.rightText = rightText
            self.leftColorStyle = leftColorStyle
            self.rightColorStyle = rightColorStyle
        }
    }

    private let config: Configuration
    private let layout: TXButtonGroupLayout
    private let actionLeft: () -> Void
    private let actionRight: () -> Void

    public init(
        config: Configuration = .modal(),
        layout: TXButtonGroupLayout = .modal,
        actionLeft: @escaping () -> Void,
        actionRight: @escaping () -> Void
    ) {
        self.config = config
        self.layout = layout
        self.actionLeft = actionLeft
        self.actionRight = actionRight
    }

    public var body: some View {
        HStack(spacing: config.spacing) {
            leftButton
            rightButton
        }
        .padding(.vertical, config.verticalPadding)
        .padding(.horizontal, config.horizontalPadding)
    }
}

// MARK: - SubViews
private extension TXRoundedRectangleGroupButton {
    var leftButton: some View {
        Group {
            TXRoundedRectangleButton(
                config: buttonConfig(
                    text: config.leftText,
                    colorStyle: config.leftColorStyle
                ),
                action: actionLeft
            )
            .frame(maxWidth: layout == .calendarSheet ? .infinity : nil)
        }
    }

    var rightButton: some View {
        Group {
            TXRoundedRectangleButton(
                config: buttonConfig(
                    text: config.rightText,
                    colorStyle: config.rightColorStyle
                ),
                action: actionRight
            )
            .frame(maxWidth: layout == .calendarSheet ? .infinity : nil)
        }
    }

    func buttonConfig(text: String, colorStyle: ColorStyle) -> TXRoundedRectangleButton.Configuration {
        switch layout {
        case .calendarSheet:
            return .long(text: text, colorStyle: colorStyle)
        case .modal:
            return .medium(text: text, colorStyle: colorStyle)
        }
    }
}

#Preview {
    TXRoundedRectangleGroupButton(
        config: .modal(),
        actionLeft: { },
        actionRight: { }
    )
}
