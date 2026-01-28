//
//  ColorStyle.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/17/26.
//

import SwiftUI

/// 디자인 시스템 버튼/컴포넌트에서 사용하는 색상 스타일 집합입니다.
public enum ColorStyle {
    case black
    case white
    case gray200
    case gray300
    case gray400
    case disabled
}

extension ColorStyle {
    var foregroundColor: Color {
        switch self {
        case .black, .gray200, .gray300, .gray400:
            return Color.Common.white

        case .white:
            return Color.Gray.gray500

        case .disabled:
            return Color.Gray.gray300
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

        case .gray300:
            return Color.Gray.gray300

        case .gray400:
            return Color.Gray.gray400

        case .disabled:
            return Color.Gray.gray100
        }
    }

    var borderColor: Color {
        switch self {
        case .disabled:
            return Color.Gray.gray100

        default:
            return Color.Gray.gray500
        }
    }
}
