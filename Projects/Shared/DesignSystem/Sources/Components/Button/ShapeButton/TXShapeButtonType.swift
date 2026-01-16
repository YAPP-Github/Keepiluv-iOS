//
//  TXShapeButtonType.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/15/26.
//

import SwiftUI

/// Shape 기반 버튼의 스타일과 콘텐츠 구성을 정의합니다.
public enum TXShapeButtonType {
    case smallRoundedRectangle(config: TextConfig)
    case mediumRoundedRectangle(config: TextConfig)
    case longRoundedRectangle(config: TextConfig)
    case circle(config: IconConfig)
    case rectangle(config: RectangleConfig)
    
    /// 텍스트 버튼에 필요한 구성을 정의합니다.
    public struct TextConfig {
        let text: String
        let backgroundColor: Color
        let foregroundColor: Color
        
        public init(text: String, backgroundColor: Color, foregroundColor: Color) {
            self.text = text
            self.backgroundColor = backgroundColor
            self.foregroundColor = foregroundColor
        }
    }
    
    /// 아이콘 버튼에 필요한 구성을 정의합니다.
    public struct IconConfig {
        let frameSize: CGSize
        let image: Image
        let imageSize: CGSize
        let backgroundColor: Color
        let foregroundColor: Color
        
        public init(frameSize: CGSize, image: Image, imageSize: CGSize, backgroundColor: Color, foregroundColor: Color) {
            self.frameSize = frameSize
            self.image = image
            self.imageSize = imageSize
            self.backgroundColor = backgroundColor
            self.foregroundColor = foregroundColor
        }
    }
    
    /// 사각형 버튼에 필요한 구성을 정의합니다.
    public struct RectangleConfig {
        let edges: [Edge]
        let frameSize: CGSize
        let backgroundColor: Color
        let foregroundColor: Color
        let content: RectangleContent
        
        public init(edges: [Edge], frameSize: CGSize, backgroundColor: Color, foregroundColor: Color, content: RectangleContent) {
            self.edges = edges
            self.frameSize = frameSize
            self.backgroundColor = backgroundColor
            self.foregroundColor = foregroundColor
            self.content = content
        }
    }
    
    /// 사각형 버튼의 콘텐츠 유형을 정의합니다.
    public enum RectangleContent {
        case text(String)
        case icon(image: Image, imageSize: CGSize)
    }
}

extension TXShapeButtonType {
    var font: TypographyToken? {
        switch self {
        case .smallRoundedRectangle:
            return .b1_14b

        case .mediumRoundedRectangle, .longRoundedRectangle:
            return .t2_16b

        case .rectangle(let config):
            switch config.content {
            case .text:
                return .t2_16b
            case .icon:
                return nil
            }

        default:
            return nil
        }
    }

    func width() -> CGFloat? {
        switch self {
        case .smallRoundedRectangle:
            return 77

        case .mediumRoundedRectangle:
            return 151

        case .longRoundedRectangle:
            return .infinity

        case .circle(let config):
            return config.frameSize.width

        case .rectangle(let config):
            return config.frameSize.width
        }
    }

    func height() -> CGFloat? {
        switch self {
        case .smallRoundedRectangle:
            return 32

        case .mediumRoundedRectangle, .longRoundedRectangle:
            return 52

        case .circle(let config):
            return config.frameSize.height

        case .rectangle(let config):
            return config.frameSize.height
        }
    }

    func radius() -> CGFloat {
        switch self {
        case .smallRoundedRectangle:
            return Radius.xs

        case .mediumRoundedRectangle, .longRoundedRectangle:
            return Radius.s

        case .circle(let config):
            return config.frameSize.width / 2

        case .rectangle:
            return .zero
        }
    }

    var borderWidth: CGFloat {
        switch self {
        case .smallRoundedRectangle, .mediumRoundedRectangle, .longRoundedRectangle, .circle, .rectangle:
            return LineWidth.m
        }
    }

    var borderColor: Color {
        switch self {
        case .smallRoundedRectangle, .mediumRoundedRectangle, .longRoundedRectangle, .circle, .rectangle:
            return Color.Gray.gray500
        }
    }

    var borderEdges: [Edge]? {
        switch self {
        case let .rectangle(config):
            return config.edges
        default:
            return nil
        }
    }

    var text: String? {
        switch self {
        case .smallRoundedRectangle(let config),
             .mediumRoundedRectangle(let config),
             .longRoundedRectangle(let config):
            return config.text

        case .rectangle(let config):
            if case let .text(text) = config.content {
                return text
            }
            return nil

        default:
            return nil
        }
    }

    var image: Image? {
        switch self {
        case .circle(let config):
            return config.image

        case .rectangle(let config):
            if case let .icon(image, _) = config.content {
                return image
            }
            return nil

        default:
            return nil
        }
    }

    var imageSize: CGSize? {
        switch self {
        case .circle(let config):
            return config.imageSize

        case .rectangle(let config):
            if case let .icon(_, imageSize) = config.content {
                return imageSize
            }
            return nil

        default:
            return nil
        }
    }

    var backgroundColor: Color {
        switch self {
        case .smallRoundedRectangle(let config),
             .mediumRoundedRectangle(let config),
             .longRoundedRectangle(let config):
            return config.backgroundColor

        case .circle(let config):
            return config.backgroundColor

        case .rectangle(let config):
            return config.backgroundColor
        }
    }

    var foregroundColor: Color {
        switch self {
        case .smallRoundedRectangle(let config),
             .mediumRoundedRectangle(let config),
             .longRoundedRectangle(let config):
            return config.foregroundColor

        case .circle(let config):
            return config.foregroundColor

        case .rectangle(let config):
            return config.foregroundColor
        }
    }
}
