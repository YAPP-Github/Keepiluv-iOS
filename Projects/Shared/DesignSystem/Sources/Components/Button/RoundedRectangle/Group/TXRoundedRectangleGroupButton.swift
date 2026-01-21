//
//  TXRoundedRectangleGroupButton.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/18/26.
//

import SwiftUI

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
    private let actionLeft: () -> Void
    private let actionRight: () -> Void
    
    public init(
        config: Configuration = .modal(),
        actionLeft: @escaping () -> Void,
        actionRight: @escaping () -> Void
    ) {
        self.config = config
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
        TXRoundedRectangleButton(
            config: .medium(
                text: config.leftText,
                colorStyle: config.leftColorStyle
            ),
            action: actionLeft
        )
    }
    
    var rightButton: some View {
        TXRoundedRectangleButton(
            config: .medium(
                text: config.rightText,
                colorStyle: config.rightColorStyle
            ),
            action: actionRight
        )
    }
}

#Preview {
    TXRoundedRectangleGroupButton(
        config: .modal(),
        actionLeft: { },
        actionRight: { }
    )
}
