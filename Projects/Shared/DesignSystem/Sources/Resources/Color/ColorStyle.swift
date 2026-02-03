//
//  ColorStyle.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/17/26.
//

import SwiftUI

public enum ColorStyle {
    case black
    case white
    case gray200
    case gray300
    case gray400
    case disable
}

extension ColorStyle {
    var foregroundColor: Color {
        switch self {
        case .black, .gray200, .gray300, .gray400:
            return Color.Common.white

        case .white:
            return Color.Gray.gray500
            
        case .disable:
            return Color.Gray.gray300
        }
    }

    var backgroundColor: Color {
        switch self {
        case .black:
            return Color.Gray.gray500

        case .white:
            return Color.Common.white
            
        case .disable:
            return Color.Gray.gray100

        case .gray200:
            return Color.Gray.gray200

        case .gray300:
            return Color.Gray.gray300

        case .gray400:
            return Color.Gray.gray400
        }
    }

    var borderColor: Color {
        return Color.Gray.gray500
    }
}
