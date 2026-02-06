//
//  Typography.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/13/26.
//

import SwiftUI

// swiftlint:disable identifier_name
// Figma 이름 그대로 따라가기 위해 disable
/// 모듈 전반에서 공통으로 사용하는 Typography 토큰입니다.
public enum TypographyToken {
    case h1_28b
    case h2_24r
    case h3_22b
    case h3_22eb
    case h4_20b
    case t1_18eb
    case t2_16b
    case t2_16eb
    case t3_14eb
    case b1_14b
    case b2_14r
    case b3_12eb
    case b4_12b
    case c1_12r
    case c2_11b
}
// swiftlint:enable identifier_name

extension TypographyToken {
    var font: SharedDesignSystemFontConvertible {
        switch self {
        case .h1_28b, .t2_16b, .b1_14b, .b4_12b, .c2_11b:
            return SharedDesignSystemFontFamily.NanumSquareNeoOTF.bold
            
        case .h2_24r, .b2_14r, .c1_12r:
            return SharedDesignSystemFontFamily.NanumSquareNeoOTF.regular
            
        case .h3_22b, .h4_20b:
            return SharedDesignSystemFontFamily.LaundryGothicOTF.bold
            
        case .t1_18eb, .t3_14eb, .t2_16eb, .b3_12eb, .h3_22eb:
            return SharedDesignSystemFontFamily.NanumSquareNeoOTF.extraBold
        }
    }

    var size: CGFloat {
        switch self {
        case .h1_28b:
            return 28
            
        case .h2_24r:
            return 24
            
        case .h3_22b, .h3_22eb:
            return 22
            
        case .h4_20b:
            return 20
            
        case .t1_18eb:
            return 18
            
        case .t2_16b, .t2_16eb:
            return 16
            
        case .t3_14eb, .b1_14b, .b2_14r:
            return 14
            
        case .b3_12eb, .b4_12b, .c1_12r:
            return 12
            
        case .c2_11b:
            return 11
        }
    }

    var lineHeightMultiplier: CGFloat {
        switch self {
        case .h1_28b, .h2_24r, .h3_22b, .h3_22eb, .h4_20b:
            return 1.40
            
        case .t1_18eb, .t2_16b, .t2_16eb, .t3_14eb, .b1_14b, .b2_14r, .b3_12eb, .b4_12b, .c1_12r, .c2_11b:
            return 1.50
        }
    }

    var letterSpacingPercent: CGFloat {
        switch self {
        case .h1_28b, .h2_24r, .h3_22b, .h3_22eb, .t3_14eb, .b3_12eb:
            return -0.01
            
        case .h4_20b, .t1_18eb, .t2_16b, .t2_16eb:
            return -0.02
            
        case .b1_14b, .b2_14r, .b4_12b, .c1_12r, .c2_11b:
            return -0.025
        }
    }
    
    var lineSpacing: CGFloat {
        return (size * lineHeightMultiplier - size) / 2
    }

    var kerning: CGFloat {
        return size * letterSpacingPercent
    }
}
