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
    case gray400
}

extension ColorStyle {
    var foregroundColor: Color {
        switch self {
        case .black:
            return Color.Common.white
            
        case .white:
            return Color.Gray.gray500
            
        case .gray200, .gray400:
            return Color.Common.white
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .black:
            return Color.Gray.gray500
            
        case .white:
            return Color.Common.white
            
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
