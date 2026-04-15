//
//  TXRectGroupButton.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/18/26.
//

import SwiftUI

public struct TXRectGroupButton: View {
    private let leftShape: TXButtonShape
    private let rightShape: TXButtonShape
    private let spacing: CGFloat
    private let horizontalPadding: CGFloat
    private let onTapLeft: () -> Void
    private let onTapRight: () -> Void

    public init(
        leftShape: TXButtonShape,
        rightShape: TXButtonShape,
        spacing: CGFloat = Spacing.spacing5,
        horizontalPadding: CGFloat = Spacing.spacing8,
        onTapLeft: @escaping () -> Void,
        onTapRight: @escaping () -> Void
    ) {
        self.leftShape = leftShape
        self.rightShape = rightShape
        self.spacing = spacing
        self.horizontalPadding = horizontalPadding
        self.onTapLeft = onTapLeft
        self.onTapRight = onTapRight
    }

    public var body: some View {
        HStack(spacing: spacing) {
            leftButton
            rightButton
        }
        .padding(.horizontal, horizontalPadding)
    }
}

private extension TXRectGroupButton {
    var leftButton: some View {
        TXButton(
            shape: leftShape,
            onTap: onTapLeft
        )
    }

    var rightButton: some View {
        TXButton(
            shape: rightShape,
            onTap: onTapRight
        )
    }
}

#Preview {
    TXRectGroupButton(
        leftShape: .rect(
            style: .basic(text: "취소"),
            size: .m,
            state: .line
        ),
        rightShape: .rect(
            style: .basic(text: "삭제"),
            size: .m,
            state: .standard
        ),
        onTapLeft: { },
        onTapRight: { }
    )
}
