//
//  TXRoundedRectangleButtonStyle.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/17/26.
//

import Foundation

extension TXRoundedRectangleButton {
    /// 라운드 사각형 버튼의 크기와 콘텐츠 조합을 정의합니다.
    public enum Style {
        case small(content: SmallContent, colorStyle: ColorStyle)
        case medium(content:MediumContent, colorStyle: ColorStyle)
        case long(content:LongContent, colorStyle: ColorStyle)
    }
}

extension TXRoundedRectangleButton.Style {
    var fixedFrame: Bool {
        switch self {
        case .small:
            return false
        case .medium, .long:
            return true
        }
    }

    var width: CGFloat? {
        switch self {
        case .small:
            return nil
            
        case .medium:
            return 151
            
        case .long:
            return .infinity
        }
    }
    
    var height: CGFloat? {
        switch self {
        case .small:
            return nil
            
        case .medium, .long:
            return 52
            
        }
    }
    
    var horizontalPadding: CGFloat? {
        switch self {
        case let .small(content, _):
            return content.horizontalPadding
            
        case .medium, .long:
            return nil
        }
    }
    
    var verticalPadding: CGFloat? {
        switch self {
        case let .small(content, _):
            return content.verticalPadding
            
        case .medium, .long:
            return nil
        }
    }
    
    var font: TypographyToken {
        switch self {
        case .small:
            return .b1_14b
            
        case .medium, .long:
            
            return .t2_16b
        }
    }

    var radius: CGFloat {
        switch self {
        case .small:
            return Radius.xs
            
        case .medium, .long:
            return Radius.s
        }
    }
    
    var borderWidth: CGFloat {
        switch self {
        case .small, .medium, .long:
            return LineWidth.m
        }
    }
    
    var text: String {
        switch self {
        case let .small(content, _):
            return content.text
            
        case let .medium(content, _):
            return content.text
            
        case let .long(content, _):
            return content.text
            
        }
    }
    
    var colorStyle: ColorStyle {
        switch self {
        case let .small(_ ,colorStyle):
            return colorStyle
            
        case let .medium(_ ,colorStyle):
            return colorStyle
            
        case let .long(_ ,colorStyle):
            return colorStyle
        }
    }
}
