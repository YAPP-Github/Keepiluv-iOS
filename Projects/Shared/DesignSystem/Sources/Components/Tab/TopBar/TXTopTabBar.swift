//
//  TopTabBar.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/18/26.
//

import SwiftUI

/// 상단 탭 전환을 제공하는 컴포넌트입니다.
///
/// ## 사용 예시
/// ```swift
/// TopTabBar(style: .plain(content: .goal)) { item in
///     print(item)
/// }
/// ```
public struct TXTopTabBar: View {
    public typealias Item = Style.Item
    
    @State private var selectedItem: Item = .inProgress
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
        HStack(spacing: 0) {
            ForEach(style.items, id: \.self) { item in
                Button {
                    selectedItem = item
                    onSelect(item)
                } label: {
                    tabItem(title: item.title, isSelected: selectedItem == item)
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity)
            }
        }
    }
}

// MARK: - SubViews
private extension TXTopTabBar {
    func tabItem(title: String, isSelected: Bool) -> some View {
        let color = isSelected ? style.selectedColor : style.unselectedColor
        
        return Text(title)
            .typography(style.font)
            .foregroundStyle(color)
            .frame(maxWidth: .infinity, maxHeight: style.height)
            .padding(.bottom, style.bottomPadding)
            .overlay(
                Rectangle()
                    .foregroundStyle(color)
                    .frame(height: style.underlineHeight)
                    .padding(.bottom, style.underlineBottomPadding),
                alignment: .bottom
            )
    }
}

#Preview {
    VStack {
        TXTopTabBar(style: .plain(content: .goal))
        
        Spacer()
    }
}
