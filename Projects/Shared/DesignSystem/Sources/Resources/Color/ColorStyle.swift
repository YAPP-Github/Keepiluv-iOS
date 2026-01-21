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
    case gray
    case toast
    case gray200
    case gray400
}

extension ColorStyle {
    var foregroundColor: Color {
        switch self {
        case .black:
            return Color.Common.white

        case .white:
            return Color.Gray.gray500

        case .gray, .toast:
            return Color.Common.white
        }
    }

    var backgroundColor: Color {
        switch self {
        case .black:
            return Color.Gray.gray500

        case .white:
            return Color.Common.white

        case .gray:
            return Color.Gray.gray200

        case .toast:
            return Color.Gray.gray300
            
        case .gray200:
            return Color.Gray.gray200
            
        case .gray400:
            return Color.Gray.gray400
        }
    }

    var borderColor: Color {
        return Color.Gray.gray500
    }
}
