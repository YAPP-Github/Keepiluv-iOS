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
///     config: .goalCheck(),
///     isMyChecked: isMyChecked,
///     isCoupleChecked: isCoupleChecked,
///     action: { }
/// )
/// ```
public struct TXToggleButton: View {
    public enum Item {
        case myCheck
        case coupleCheck
    }
    
    public struct Configuration {
        public let items: [Item]
        public let spacing: CGFloat
        public let leftImage: Image
        public let leftSelectedImage: Image
        public let rightImage: Image
        public let rightSelectedImage: Image
        
        public init(
            items: [Item],
            spacing: CGFloat,
            leftImage: Image,
            leftSelectedImage: Image,
            rightImage: Image,
            rightSelectedImage: Image,
        ) {
            self.items = items
            self.spacing = spacing
            self.leftImage = leftImage
            self.leftSelectedImage = leftSelectedImage
            self.rightImage = rightImage
            self.rightSelectedImage = rightSelectedImage
        }
    }
    
    private let config: Configuration
    private let isMyChecked: Bool
    private let isCoupleChecked: Bool
    private let action: () -> Void

    public init(
        config: Configuration,
        isMyChecked: Bool,
        isCoupleChecked: Bool,
        action: @escaping () -> Void
    ) {
        self.config = config
        self.isMyChecked = isMyChecked
        self.isCoupleChecked = isCoupleChecked
        self.action = action
    }
    
    public var body: some View {
        HStack(spacing: config.spacing) {
            ForEach(config.items, id: \.self) { item in
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
        image(for: item, isSelected: isSelected)
            .zIndex(zIndex(for: item))
            .onTapGesture {
                action()
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
    
    func image(for item: Item, isSelected: Bool) -> Image {
        switch item {
        case .myCheck:
            return isSelected ? config.leftSelectedImage : config.leftImage
            
        case .coupleCheck:
            return isSelected ? config.rightSelectedImage : config.rightImage
        }
    }
    
    func zIndex(for item: Item) -> Double {
        switch item {
        case .myCheck:
            return 2
            
        case .coupleCheck:
            return 1
        }
    }
}

#Preview {
    @Previewable @State var isMyChecked = false
    
    VStack {
        TXToggleButton(
            config: .goalCheck(),
            isMyChecked: isMyChecked,
            isCoupleChecked: true,
            action: { isMyChecked.toggle() }
        )
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.cyan)
}
