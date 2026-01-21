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
/// TXRoundedRectangleGroupButton(style: .plain(.modal)) {
///     print("cancel")
/// } actionRight: {
///     print("delete")
/// }
/// ```
public struct TXRoundedRectangleGroupButton: View {
    
    typealias Item = TXRoundedRectangleGroupButton.Style.Item

    private let style: Style
    private let actionLeft: () -> Void
    private let actionRight: () -> Void
    
    public init(
        style: Style = .plain(.modal),
        actionLeft: @escaping () -> Void,
        actionRight: @escaping () -> Void
    ) {
        self.style = style
        self.actionLeft = actionLeft
        self.actionRight = actionRight
    }

    public var body: some View {
        HStack(spacing: style.spacing) {
            ForEach(style.items, id: \.self) { item in
                groupButton(item)
            }
        }
        .padding(.vertical, Spacing.spacing5)
        .padding(.horizontal, Spacing.spacing8)
    }
}

// MARK: - SubViews
private extension TXRoundedRectangleGroupButton {
    @ViewBuilder
    func groupButton(_ item: Item) -> some View {
        TXRoundedRectangleButton(
            style: .medium(
                content: item.buttonContent,
                colorStyle: item.colorStyle
            ),
            action: action(for: item)
        )
    }
}

// MARK: - Helpers
private extension TXRoundedRectangleGroupButton {
    func action(for item: Item) -> () -> Void {
        style.action(
            for: item,
            actionLeft: actionLeft,
            actionRight: actionRight
        )
    }
}
