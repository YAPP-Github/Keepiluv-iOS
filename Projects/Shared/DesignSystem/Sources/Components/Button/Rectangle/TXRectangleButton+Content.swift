//
//  TXRectangleButton+Content.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/17/26.
//

import SwiftUI

extension TXRectangleButton {
    /// 사각형 버튼의 콘텐츠 타입을 정의합니다.
    public enum Content {
        case save
        case close
        case back
    }
}

extension TXRectangleButton.Content {
    var text: String? {
        switch self {
        case .save:
            return "저장"
            
        case .close, .back:
            return nil
        }
    }

    var image: Image? {
        switch self {
        case .save:
            return nil
            
        case .close:
            return Image.Icon.Symbol.closeM
            
        case .back:
            return Image.Icon.Symbol.arrow3Left
        }
    }

    var imageSize: CGSize? {
        switch self {
        case .save:
            return nil
            
        case .close, .back:
            return CGSize(width: 24, height: 24)
        }
    }
}
