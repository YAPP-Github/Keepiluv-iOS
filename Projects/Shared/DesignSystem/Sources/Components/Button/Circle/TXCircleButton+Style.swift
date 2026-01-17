//
//  TXCircleButton+Style.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/17/26.
//

import SwiftUI

extension TXCircleButton {
    /// 원형 버튼의 레이아웃과 콘텐츠 조합을 정의합니다.
    public enum Style {
        case small(content: Content, colorStyle: ColorStyle)
        case medium(content: Content, colorStyle: ColorStyle)
    }
}

extension TXCircleButton.Style {
    var frameSize: CGSize {
        switch self {
        case let .small(content, _):
            return content.frameSize
            
        case let .medium(content, _):
            return content.frameSize
        }
    }

    var imageSize: CGSize {
        switch self {
        case let .small(content, _):
            return content.imageSize
            
        case let .medium(content, _):
            return content.imageSize
        }
    }

    var image: Image {
        switch self {
        case let .small(content, _):
            return content.image
            
        case let .medium(content, _):
            return content.image
        }
    }

    var colorStyle: ColorStyle {
        switch self {
        case let .small(_, colorStyle):
            return colorStyle
            
        case let .medium(_, colorStyle):
            return colorStyle
        }
    }
}
