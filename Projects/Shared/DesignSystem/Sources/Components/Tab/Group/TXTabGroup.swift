//
//  TapGroup.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/18/26.
//

import SwiftUI

/// 여러 개의 TXRoundedRectangleButton 텍스트 버튼을 그룹으로 제공하는 컴포넌트입니다.
///
/// ## 사용 예시
/// ```swift
/// TXTabGroup(config: .period()) { item in
///     print(item)
/// }
/// ```
public struct TXTabGroup: View {
    public struct Configuration {
        let items: [String]
        let spacing: CGFloat = Spacing.spacing5
        let selectedColorStyle: ColorStyle
        let unselectedColorStyle: ColorStyle

        public init(
            items: [String],
            selectedColorStyle: ColorStyle,
            unselectedColorStyle: ColorStyle
        ) {
            self.items = items
            self.selectedColorStyle = selectedColorStyle
            self.unselectedColorStyle = unselectedColorStyle
        }
    }

    public typealias Item = String
    
    @State private var selectedItem: Item?
    private let config: Configuration
    private let onSelect: (Item) -> Void
    
    public init(
        config: Configuration,
        onSelect: @escaping (Item) -> Void = { _ in }
    ) {
        self.config = config
        self.onSelect = onSelect
    }
    
    public var body: some View {
        HStack(spacing: config.spacing) {
            ForEach(config.items, id: \.self) { item in
                tabItem(item)
            }
        }
    }
}

// MARK: - SubViews
private extension TXTabGroup {
    func tabItem(_ item: Item) -> some View {
        TXRoundedRectangleButton(
            config: .small(
                text: item,
                colorStyle: selectedItem == item
                ? config.selectedColorStyle
                : config.unselectedColorStyle
            )
        ) {
            selectedItem = item
            onSelect(item)
        }
    }
}

#Preview {
    TXTabGroup(config: .period())
}
