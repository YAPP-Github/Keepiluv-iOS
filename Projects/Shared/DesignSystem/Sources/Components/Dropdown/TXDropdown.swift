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
/// TXDropdown { item in
///     print(item)
/// }
/// ```
public struct TXDropdown: View {
    public typealias Item = TXDropdown.Style.Item
    
    private let style: Style
    private let onSelect: (Item) -> Void
    
    public init(
        style: Style = .config(.goal),
        onSelect: @escaping (Item) -> Void
    ) {
        self.style = style
        self.onSelect = onSelect
    }

    public var body: some View {
        VStack(spacing: 0) {
            ForEach(style.items.indices, id: \.self) { index in
                dropdownItem(at: index)
                
                if index != style.items.indices.last {
                    divider
                }
            }
        }
        .insideBorder(
            style.borderColor,
            shape: RoundedRectangle(cornerRadius: style.radius),
            lineWidth: style.borderWidth
        )
        .shadow(
            color: style.shadowColor,
            radius: style.shadowRadius,
            x: style.shadowX,
            y: style.shadowY
        )
        .frame(width: style.width)
    }
}

// MARK: - SubViews
private extension TXDropdown {
    func dropdownItem(at index: Int) -> some View {
        Text(style.items[index].title)
            .typography(style.font)
            .foregroundStyle(style.foregroundColor)
            .frame(maxWidth: .infinity, maxHeight: style.itemHeight, alignment: .leading)
            .padding(.leading, style.leadingPadding)
    }
    
    var divider: some View {
        Rectangle()
            .frame(height: style.separatorHeight)
            .foregroundStyle(style.separatorColor)
    }
}

#Preview {
    VStack {
        TXDropdown(style: .config(.goal), onSelect: { _ in })
    }
}
