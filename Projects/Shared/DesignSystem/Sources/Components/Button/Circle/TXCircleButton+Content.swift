//
//  TXCircleButton+Content.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/17/26.
//

import SwiftUI

extension TXCircleButton {
    /// 원형 버튼의 콘텐츠 타입을 정의합니다.
    public enum Content {
        case plus
        case clear
    }
}

extension TXCircleButton.Content {
    var image: Image {
        switch self {
        case .plus:
            return Image.Icon.Symbol.plus
            
        case .clear:
            return Image.Icon.Symbol.closeS
        }
    }
    
    var frameSize: CGSize {
        switch self {
        case .plus:
            return CGSize(width: 56, height: 56)
            
        case .clear:
            return CGSize(width: 18, height: 18)
        }
    }
    
    var imageSize: CGSize {
        switch self {
        case .plus:
            return CGSize(width: 44, height: 44)
            
        case .clear:
            return CGSize(width: 24, height: 24)
        }
    }
}
