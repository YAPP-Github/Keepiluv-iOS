//
//  TXRectangleButton+Style.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/17/26.
//

import SwiftUI

extension TXRectangleButton {
    /// 사각형 버튼의 레이아웃과 콘텐츠 조합을 정의합니다.
    public enum Style {
        case blankRight(content: Content, colorStyle: ColorStyle)
        case blankLeft(content: Content, colorStyle: ColorStyle)
    }
}

extension TXRectangleButton.Style {
    var frameSize: CGSize {
        switch self {
        case .blankLeft, .blankRight:
            return CGSize(width: 60, height: 60)
        }
    }

    var font: TypographyToken? {
        switch self {
        case let .blankLeft(content, _):
            guard let _ = content.text else { return nil }
            return .t2_16b
            
        case let .blankRight(content, _):
            guard let _ = content.text else { return nil }
            return .t2_16b
        }
    }

    var text: String? {
        switch self {
        case let .blankLeft(content, _):
            return content.text
            
        case let .blankRight(content, _):
            return content.text
        }
    }

    var image: Image? {
        switch self {
        case let .blankLeft(content, _):
            return content.image
            
        case let .blankRight(content, _):
            return content.image
        }
    }

    var imageSize: CGSize? {
        switch self {
        case let .blankLeft(content, _):
            return content.imageSize
            
        case let .blankRight(content, _):
            return content.imageSize
        }
    }

    var colorStyle: ColorStyle {
        switch self {
        case let .blankLeft(_, colorStyle):
            return colorStyle
            
        case let .blankRight(_, colorStyle):
            return colorStyle
        }
    }

    var borderWidth: CGFloat {
        switch self {
        case .blankLeft, .blankRight:
            return LineWidth.m
        }
    }
    
    var edges: [Edge] {
        switch self {
        case .blankLeft:
            return [.top, .bottom, .trailing]
            
        case .blankRight:
            return [.top, .bottom, .leading]
        }
    }
}
