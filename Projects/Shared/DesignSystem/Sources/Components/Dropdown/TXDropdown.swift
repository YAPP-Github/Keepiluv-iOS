//
//  TXDropdown.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/18/26.
//

import SwiftUI

public protocol TXItem: CaseIterable, Equatable, Hashable {
    var title: String { get }
}

/// 드롭다운 선택지를 제공하는 컴포넌트입니다.
///
/// ## 사용 예시
/// ```swift
/// enum MenuItem: String, TXItem {
///     case first
///     case second
///
///     var title: String { rawValue }
/// }
///
/// TXDropdown(items: MenuItem.allCases) { item in
///     print(item)
/// }
/// ```
public struct TXDropdown<Item: TXItem>: View {
    private let items: [Item]
    private let onSelect: (Item) -> Void
    
    /// 드롭다운 항목, 표시 문구, 선택 액션으로 드롭다운을 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// TXDropdown(
    ///     items: items
    /// ) { item in
    ///     print(item)
    /// }
    /// ```
    public init(
        items: [Item],
        onSelect: @escaping (Item) -> Void
    ) {
        self.items = items
        self.onSelect = onSelect
    }

    public var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                Button {
                    onSelect(item)
                } label: {
                    dropdownItem(
                        item,
                        showsBottomDivider: index != items.indices.last
                    )
                }
            }
        }
        .background(
            Color.Common.white,
            in: RoundedRectangle(cornerRadius: Constants.cornerRadius)
        )
        .insideBorder(
            Constants.borderColor,
            shape: RoundedRectangle(cornerRadius: Constants.cornerRadius),
            lineWidth: Constants.borderWidth
        )
        .shadow(
            color: Constants.shadowColor,
            radius: Constants.shadowRadius,
            x: Constants.shadowX,
            y: Constants.shadowY
        )
        .frame(width: Constants.width)
    }
}

// MARK: - SubViews
private extension TXDropdown {
    func dropdownItem(
        _ item: Item,
        showsBottomDivider: Bool
    ) -> some View {
        Text(item.title)
            .typography(Constants.textTypography)
            .foregroundStyle(Constants.textColor)
            .frame(maxWidth: .infinity, maxHeight: Constants.itemHeight, alignment: .leading)
            .padding(.leading, Constants.leadingPadding)
            .insideRectEdgeBorder(
                width: Constants.borderWidth,
                edges: showsBottomDivider ? [.bottom] : [],
                color: Constants.dividerColor
            )
    }
}

// MARK: - Constants
private enum Constants {
    static let width: CGFloat = 88
    static let itemHeight: CGFloat = 44
    static let leadingPadding: CGFloat = Spacing.spacing7
    static let cornerRadius: CGFloat = 8
    static let borderWidth: CGFloat = LineWidth.m
    static let dividerColor: Color = Color.Gray.gray500
    static let borderColor: Color = Color.Gray.gray500
    static let textColor: Color = Color.Gray.gray500
    static let textTypography: TypographyToken = .b2_14r
    static let shadowColor: Color = .black.opacity(0.16)
    static let shadowRadius: CGFloat = 20
    static let shadowX: CGFloat = 2
    static let shadowY: CGFloat = 1
}

#Preview {
    VStack {
        TXDropdown(items: PreviewDropdownItem.allCases, onSelect: { print($0) })
    }
}

private enum PreviewDropdownItem: String, TXItem {
    case first = "first"
    case second = "second"

    var title: String { rawValue }
}
