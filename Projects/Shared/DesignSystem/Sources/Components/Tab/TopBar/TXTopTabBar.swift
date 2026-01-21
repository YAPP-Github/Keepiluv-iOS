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
/// TXTopTabBar(config: .goal()) { item in
///     print(item)
/// }
/// ```
public struct TXTopTabBar: View {
    public struct Configuration {
        let items: [String]
        let font: TypographyToken = .t2_16b
        let selectedColor: Color = Color.Gray.gray500
        let unselectedColor: Color = Color.Gray.gray200
        let height: CGFloat = 36
        let bottomPadding: CGFloat = Spacing.spacing6
        let underlineHeight: CGFloat = LineWidth.l
        let underlineBottomPadding: CGFloat = Spacing.spacing2
        
        public init(items: [String]) {
            self.items = items
        }
    }

    public typealias Item = String
    
    @State private var selectedItem: Item = ""
    private let config: Configuration
    private let onSelect: (Item) -> Void
    
    public init(
        config: Configuration,
        onSelect: @escaping (Item) -> Void = { _ in }
    ) {
        self.config = config
        self.onSelect = onSelect
        self._selectedItem = State(initialValue: config.items.first ?? "")
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            ForEach(config.items, id: \.self) { item in
                Button {
                    selectedItem = item
                    onSelect(item)
                } label: {
                    tabItem(title: item, isSelected: selectedItem == item)
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
        let color = isSelected ? config.selectedColor : config.unselectedColor
        
        return Text(title)
            .typography(config.font)
            .foregroundStyle(color)
            .frame(maxWidth: .infinity, maxHeight: config.height)
            .padding(.bottom, config.bottomPadding)
            .overlay(
                Rectangle()
                    .foregroundStyle(color)
                    .frame(height: config.underlineHeight)
                    .padding(.bottom, config.underlineBottomPadding),
                alignment: .bottom
            )
    }
}

#Preview {
    VStack {
        TXTopTabBar(config: .goal())
        
        Spacer()
    }
}
