//
//  TXToggleButtonType.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/15/26.
//

import SwiftUI

public enum TXToggleButtonType {
    case myCheck
    case coupleCheck
}

extension TXToggleButtonType {
    
    func fillColor(isSelected: Bool) -> Color {
        switch self {
        case .myCheck, .coupleCheck:
            return isSelected ? Color.Gray.gray500 : Color.Common.white
        }
    }
    
    func strokeBorderColor(isSelected: Bool) -> Color {
        switch self {
        case .myCheck:
            return Color.Gray.gray500
        case .coupleCheck:
            return isSelected ? Color.Gray.gray500 : Color.Gray.gray200
        }
    }
    
    func strokeBorderWidth(isSelected: Bool) -> CGFloat {
        switch self {
        case .myCheck:
            return 1
        case .coupleCheck:
            return isSelected ? 0 : 1
        }
    }
    
    var strokeColor: Color {
        switch self {
        case .myCheck:
            return Color.Common.white
        case .coupleCheck:
            return .clear
        }
    }
    
    var strokeWidth: CGFloat {
        switch self {
        case .myCheck:
            return 1.4
        case .coupleCheck:
            return 0
        }
    }
    
    var buttonFrameSize: CGFloat {
        switch self {
        case .myCheck, .coupleCheck:
            return 28
        }
    }
    
    var circleFrameSize: CGFloat {
        switch self {
        case .myCheck, .coupleCheck:
            return 24
        }
    }
    
    var checkmarkSize: CGSize {
        CGSize(width: 10, height: 8)
    }
    
    var selectedImage: Image {
        Image(systemName: "checkmark")
    }
    
    var selectedImageWidth: CGFloat {
        switch self {
        case .myCheck, .coupleCheck:
            return 10
        }
    }
    
    var selectedImageHeight: CGFloat {
        switch self {
        case .myCheck, .coupleCheck:
            return 8
        }
    }
    
    var selectedImageColor: Color {
        switch self {
        case .myCheck, .coupleCheck:
            return Color.Common.white
        }
    }
}
