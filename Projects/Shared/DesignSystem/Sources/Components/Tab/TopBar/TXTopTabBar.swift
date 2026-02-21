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
    public enum Item: CaseIterable, Equatable, Hashable {
        case ongoing
        case completed
    }
    
    public struct Configuration {
        let items: [Item]
        let font: TypographyToken = .t2_16b
        let selectedColor: Color = Color.Gray.gray500
        let unselectedColor: Color = Color.Gray.gray200
        let height: CGFloat = 36
        let bottomPadding: CGFloat = Spacing.spacing6
        let underlineHeight: CGFloat = LineWidth.l
        let underlineBottomPadding: CGFloat = Spacing.spacing2
        
        public init(items: [Item]) {
            self.items = items
        }
    }
    
    @State private var selectedItem: Item = .ongoing
    private let config: Configuration
    private let onSelect: (Item) -> Void
    
    public init(
        config: Configuration,
        onSelect: @escaping (Item) -> Void = { _ in }
    ) {
        self.config = config
        self.onSelect = onSelect
        self._selectedItem = State(initialValue: config.items.first ?? .ongoing)
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            ForEach(config.items, id: \.self) { item in
                Button {
                    selectedItem = item
                    onSelect(item)
                } label: {
                    tabItem(item: item, isSelected: selectedItem == item)
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - SubViews
private extension TXTopTabBar {
    func tabItem(item: Item, isSelected: Bool) -> some View {
        let color = isSelected ? config.selectedColor : config.unselectedColor
        
        return Text(item.title)
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

public extension TXTopTabBar.Item {
    var title: String {
        switch self {
        case .ongoing:
            return "진행중"
        case .completed:
            return "종료"
        }
    }
}

#Preview {
    VStack {
        TXTopTabBar(config: .stats)
        
        Spacer()
    }
}
