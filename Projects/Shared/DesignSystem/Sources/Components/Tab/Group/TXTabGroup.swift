//
//  TapGroup.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/18/26.
//

import SwiftUI

/// 여러 개의 TXRoundedRectangleButton.Style.SmallContent 버튼을 그룹으로 제공하는 컴포넌트입니다.
///
/// ## 사용 예시
/// ```swift
/// TabGroup(style: .plain(content: .period)) { item in
///     print(item)
/// }
/// ```
public struct TXTabGroup: View {
    public typealias Item = TXRoundedRectangleButton.Style.SmallContent
    
    @State private var selectedItem: Item?
    private let style: Style
    private let onSelect: (Item) -> Void
    
    public init(
        style: Style,
        onSelect: @escaping (Item) -> Void = { _ in }
    ) {
        self.style = style
        self.onSelect = onSelect
    }
    
    public var body: some View {
        HStack(spacing: style.spacing) {
            ForEach(style.items, id: \.self) { item in
                tabItem(item)
            }
        }
    }
}

// MARK: - SubViews
private extension TXTabGroup {
    func tabItem(_ item: Item) -> some View {
        TXRoundedRectangleButton(
            style: .small(
                content: item,
                colorStyle: selectedItem == item
                ? style.selectedColorStyle
                : style.unselectedColorStyle
            )
        ) {
            selectedItem = item
            onSelect(item)
        }
    }
}

#Preview {
    TXTabGroup(style: .plain(content: .period))
}
