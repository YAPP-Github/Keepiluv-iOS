//
//  TXTab.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 4/7/26.
//

import SwiftUI

public struct TXTab<Item: TXItem>: View {
    
    private let style: TXTabStyle<Item>
    private let selectedItem: Item?
    private let onSelect: (Item) -> Void
    
    public init(
        style: TXTabStyle<Item>,
        selectedItem: Item? = nil,
        onSelect: @escaping (Item) -> Void
    ) {
        self.style = style
        self.selectedItem = selectedItem
        self.onSelect = onSelect
    }
    
    public var body: some View {
        switch style {
        case let .button(items):
            TXTabGroup(
                selectedItem: selectedItem,
                items: items,
                onSelect: onSelect
            )
            
        case let .line(items):
            TXTopTabBar(
                items: items,
                selectedItem: selectedItem,
                onSelect: onSelect
            )
        }
    }
}

#Preview {
    TXTab(style: .button(GoalDropList.allCases), onSelect: { _ in })
}
