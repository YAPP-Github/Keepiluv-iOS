//
//  TXDropdown.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/18/26.
//

import SwiftUI

/// 드롭다운 선택지를 제공하는 컴포넌트입니다.
///
/// ## 사용 예시
/// ```swift
/// TXDropdown(config: .defaultItems()) { item in
///     print(item)
/// }
/// ```
public struct TXDropdown: View {
    public struct Configuration {
        let items: [String]
        let width: CGFloat = 88
        let itemHeight: CGFloat = 44
        let leadingPadding: CGFloat = Spacing.spacing7
        let cornerRadius: CGFloat = 8
        let borderWidth: CGFloat = LineWidth.m
        let dividerColor: Color = Color.Gray.gray500
        let borderColor: Color = Color.Gray.gray500
        let textColor: Color = Color.Gray.gray500
        let textTypography: TypographyToken = .b2_14r
        let shadowColor: Color = .black.opacity(0.16)
        let shadowRadius: CGFloat = 20
        let shadowX: CGFloat = 2
        let shadowY: CGFloat = 1

        public init(items: [String]) {
            self.items = items
        }
    }

    private let config: Configuration
    private let onSelect: (String) -> Void
    
    public init(
        config: Configuration,
        onSelect: @escaping (String) -> Void
    ) {
        self.config = config
        self.onSelect = onSelect
    }

    public var body: some View {
        dropdown
    }
}

// MARK: - SubViews
private extension TXDropdown {
    var dropdown: some View {
        VStack(spacing: 0) {
            ForEach(config.items.indices, id: \.self) { index in
                Button {
                    onSelect(config.items[index])
                } label: {
                    dropdownItem(at: index)
                }

                if index != config.items.indices.last {
                    Rectangle()
                        .frame(height: config.borderWidth)
                        .foregroundStyle(config.dividerColor)
                }
            }
        }
        .insideBorder(
            config.borderColor,
            shape: RoundedRectangle(cornerRadius: config.cornerRadius),
            lineWidth: config.borderWidth
        )
        .shadow(
            color: config.shadowColor,
            radius: config.shadowRadius,
            x: config.shadowX,
            y: config.shadowY
        )
        .frame(width: config.width)
    }
    
    func dropdownItem(at index: Int) -> some View {
        Text(config.items[index])
            .typography(config.textTypography)
            .foregroundStyle(config.textColor)
            .frame(maxWidth: .infinity, maxHeight: config.itemHeight, alignment: .leading)
            .padding(.leading, config.leadingPadding)
    }
}

#Preview {
    VStack {
        TXDropdown(config: .goal(), onSelect: { _ in })
    }
}
