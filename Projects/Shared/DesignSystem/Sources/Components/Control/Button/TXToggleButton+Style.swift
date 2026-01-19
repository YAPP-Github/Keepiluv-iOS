//
//  TXToggleButton+Style.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/15/26.
//

import SwiftUI

/// 토글 버튼 그룹의 스타일을 정의합니다.
extension TXToggleButton {
    public enum Style {
        case group(content: Content)
    }
}

extension TXToggleButton.Style {
    var items: [Item] {
        switch self {
        case let .group(content):
            return content.items
        }
    }

    var spacing: CGFloat {
        switch self {
        case .group:
            return -11
        }
    }
    
    func image(for item: Item, isSelected: Bool) -> Image {
        switch item {
        case .myCheck:
            return isSelected ? .Icon.Symbol.checkMe : .Icon.Symbol.unCheckMe
            
        case .coupleCheck:
            return isSelected ? .Icon.Symbol.checkYou : .Icon.Symbol.unCheckYou
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
