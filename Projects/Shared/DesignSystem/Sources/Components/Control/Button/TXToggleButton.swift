//
//  TXToggleButton.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/15/26.
//

import SwiftUI

/// 디자인 시스템에서 사용하는 토글 버튼 그룹 컴포넌트입니다.
///
/// ## 사용 예시
/// ```swift
/// TXToggleButton(
///     style: .group(content: .goalCheck),
///     isMyChecked: $isMyChecked,
///     isCoupleChecked: isCoupleChecked
/// )
/// ```
public struct TXToggleButton: View {
    
    public typealias Item = Style.Item
    
    private let style: Style
    @Binding public var isMyChecked: Bool
    private let isCoupleChecked: Bool

    public init(
        style: Style,
        isMyChecked: Binding<Bool>,
        isCoupleChecked: Bool
    ) {
        self.style = style
        self._isMyChecked = isMyChecked
        self.isCoupleChecked = isCoupleChecked
    }
    
    public var body: some View {
        HStack(spacing: style.spacing) {
            ForEach(style.items, id: \.self) { item in
                toggleButton(item)
            }
        }
    }
}

// MARK: - SubViews
private extension TXToggleButton {
    @ViewBuilder
    func toggleButton(_ item: Item) -> some View {
        let isSelected = isSelected(for: item)
        style.image(for: item, isSelected: isSelected)
            .zIndex(style.zIndex(for: item))
            .onTapGesture {
                isMyChecked.toggle()
            }
    }
}

// MARK: - Helpers
private extension TXToggleButton {
    func isSelected(for item: Item) -> Bool {
        switch item {
        case .myCheck:
            return isMyChecked
            
        case .coupleCheck:
            return isCoupleChecked
        }
    }
}

#Preview {
    @Previewable @State var isMyChecked = false
    
    VStack {
        TXToggleButton(
            style: .group(content: .goalCheck),
            isMyChecked: $isMyChecked,
            isCoupleChecked: true
        )
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.cyan)
}
