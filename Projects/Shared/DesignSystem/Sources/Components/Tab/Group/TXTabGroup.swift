//
//  TapGroup.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/18/26.
//

import SwiftUI

struct TXTabGroup<Item: TXItem>: View {
    let selectedItem: Item?
    let items: [Item]
    let onSelect: (Item) -> Void

    var body: some View {
        HStack(spacing: Constants.spacing) {
            ForEach(items, id: \.self) { item in
                tabItem(item)
            }
        }
    }
}

// MARK: - Constants
private enum Constants {
    static let spacing: CGFloat = Spacing.spacing5
    static let selectedState: TXButtonShape.TXRectState = .standard
    static let unselectedState: TXButtonShape.TXRectState = .line
    static let typography: TypographyToken = .b2_14r
}

// MARK: - SubViews
private extension TXTabGroup {
    func tabItem(_ item: Item) -> some View {
        TXButton(
            shape: .rect(
                style: .basic(text: item.title, typography: Constants.typography),
                size: .s,
                state: selectedItem == item
                ? Constants.selectedState
                : Constants.unselectedState
            ),
            onTap: {
                onSelect(item)
            }
        )
    }
}

#Preview {
}
