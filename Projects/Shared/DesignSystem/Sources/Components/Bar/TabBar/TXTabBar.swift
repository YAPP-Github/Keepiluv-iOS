//
//  TXTabBar.swift
//  SharedDesignSystem
//
//  Created by 정지용 on 1/22/26.
//

import SwiftUI

/// 하단 탭바 컴포넌트입니다.
/// - Note: 외부에서 직접 사용하지 않고 `TXTabBarContainer`를 통해 사용합니다.
struct TXTabBar: View {
    @Binding private var selectedItem: TXTabItem

    init(selectedItem: Binding<TXTabItem>) {
        self._selectedItem = selectedItem
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(TXTabItem.visibleCases, id: \.rawValue) { item in
                    tabItemView(item: item)
                }
            }
            .frame(height: Constants.tabBarHeight)
            .background(Constants.backgroundColor)
            .insideRectEdgeBorder(
                width: Constants.borderWidth,
                edges: [.top],
                color: Constants.borderColor
            )
        }
    }
}

// MARK: - SubViews
private extension TXTabBar {
    func tabItemView(item: TXTabItem) -> some View {
        let isSelected = selectedItem == item

        return Button {
            selectedItem = item
        } label: {
            VStack(spacing: Constants.iconLabelSpacing) {
                item.icon(isSelected: isSelected)
                    .resizable()
                    .frame(width: Constants.iconSize, height: Constants.iconSize)
                    // FIXME: 삭제 예정 - 설정 탭 선택/비선택 아이콘 추가 후 제거
                    .opacity(item == .settings && !isSelected ? 0.4 : 1.0)

                Text(item.title)
                    .typography(Constants.labelFont)
                    .foregroundStyle(Constants.labelColor)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, Constants.topPadding)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Constants
private extension TXTabBar {
    enum Constants {
        static let tabBarHeight: CGFloat = 58
        static let iconSize: CGFloat = 24
        static let iconLabelSpacing: CGFloat = 4
        static let topPadding: CGFloat = 12
        static let borderWidth: CGFloat = LineWidth.m
        static let backgroundColor: Color = Color.Common.white
        static let borderColor: Color = Color.Gray.gray100
        static let labelColor: Color = Color.Gray.gray500
        static let labelFont: TypographyToken = .c2_11b
    }
}
