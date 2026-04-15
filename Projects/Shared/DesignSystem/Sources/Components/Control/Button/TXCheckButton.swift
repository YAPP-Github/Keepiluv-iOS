//
//  TXCheckButton.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/15/26.
//

import SwiftUI

/// 디자인 시스템에서 사용하는 토글 버튼 그룹 컴포넌트입니다.
///
/// ## 사용 예시
/// ```swift
/// TXCheckButton(
///     isMyChecked: isMyChecked,
///     isCoupleChecked: isCoupleChecked,
///     action: { }
/// )
/// ```
public struct TXCheckButton: View {
    public enum Item {
        case myCheck
        case coupleCheck
    }
    
    private let items: [Item] = [.myCheck, .coupleCheck]
    private let isMyChecked: Bool
    private let isCoupleChecked: Bool
    private let action: () -> Void

    public init(
        isMyChecked: Bool,
        isCoupleChecked: Bool,
        action: @escaping () -> Void
    ) {
        self.isMyChecked = isMyChecked
        self.isCoupleChecked = isCoupleChecked
        self.action = action
    }
    
    public var body: some View {
        HStack(spacing: Constants.horizontalSpacing) {
            ForEach(items, id: \.self) { item in
                toggleButton(item)
            }
        }
    }
}

// MARK: - SubViews
private extension TXCheckButton {
    @ViewBuilder
    func toggleButton(_ item: Item) -> some View {
        let isSelected = isSelected(for: item)
        image(for: item, isSelected: isSelected)
            .zIndex(item.zIndex)
            .onTapGesture {
                action()
            }
    }
}

// MARK: - Constants
private extension TXCheckButton {
    enum Constants {
        static let horizontalSpacing: CGFloat = -11
    }
}

private extension TXCheckButton.Item {
    var checkImage: Image {
        switch self {
        case .myCheck: .Icon.Symbol.unCheckMe
        case .coupleCheck: .Icon.Symbol.unCheckYou
        }
    }
    
    var selectedImage: Image {
        switch self {
        case .myCheck: .Icon.Symbol.checkMe
        case .coupleCheck: .Icon.Symbol.checkYou
        }
    }
    
    var zIndex: Double {
        switch self {
        case .myCheck: 2
        case .coupleCheck: 1
        }
    }
}

// MARK: - Private Helpers
private extension TXCheckButton {
    func image(for item: Item, isSelected: Bool) -> Image {
        isSelected ? item.selectedImage : item.checkImage
    }
    
    func isSelected(for item: Item) -> Bool {
        switch item {
        case .myCheck: isMyChecked
        case .coupleCheck: isCoupleChecked
        }
    }
}

#Preview {
    @Previewable @State var isMyChecked = false
    
    VStack {
        TXCheckButton(
            isMyChecked: isMyChecked,
            isCoupleChecked: true,
            action: { isMyChecked.toggle() }
        )
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.cyan)
}
