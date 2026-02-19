//
//  Colors.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/14/26.
//

import SwiftUI

public extension Color {
    enum Common { }
    enum Dimmed { }
    enum Gray { }
    enum Status { }
    enum Chromatic { }
}

/// 모듈 전반에서 공통으로 사용하는 Common형식의 Color 입니다.
public extension Color.Common {
    typealias CommonAsset = SharedDesignSystemAsset.ColorAssets.Common
    
    static let white = CommonAsset.commonWhite.swiftUIColor
}

/// 모듈 전반에서 공통으로 사용하는 Dimmed형식의 Color 입니다.
public extension Color.Dimmed {
    typealias DimmedAsset = SharedDesignSystemAsset.ColorAssets.Dimmed
    
    static let dimmed70 = DimmedAsset.dimmed70.swiftUIColor
    static let dimmed20 = DimmedAsset.dimmed20.swiftUIColor
}

/// 모듈 전반에서 공통으로 사용하는 Gray형식의 Color 입니다.
public extension Color.Gray {
    typealias GrayAsset = SharedDesignSystemAsset.ColorAssets.Gray
    
    static let gray50 = GrayAsset.gray50.swiftUIColor
    static let gray100 = GrayAsset.gray100.swiftUIColor
    static let gray200 = GrayAsset.gray200.swiftUIColor
    static let gray300 = GrayAsset.gray300.swiftUIColor
    static let gray400 = GrayAsset.gray400.swiftUIColor
    static let gray500 = GrayAsset.gray500.swiftUIColor
}

/// 모듈 전반에서 공통으로 사용하는 Status형식의 Color 입니다.
public extension Color.Status {
    typealias StatusAsset = SharedDesignSystemAsset.ColorAssets.Status
    
    static let success = StatusAsset.statusSuccess.swiftUIColor
    static let warning = StatusAsset.statusWarning.swiftUIColor
}

/// 모듈 전반에서 공통으로 사용하는 Status형식의 Color 입니다.
public extension Color.Chromatic {
    typealias ChromaticAsset = SharedDesignSystemAsset.ColorAssets.Chromatic
    
    static let green400 = ChromaticAsset.green400.swiftUIColor
    static let blue400 = ChromaticAsset.blue400.swiftUIColor
    static let yellow400 = ChromaticAsset.yellow400.swiftUIColor
    static let pink400 = ChromaticAsset.pink400.swiftUIColor
    static let pink300 = ChromaticAsset.pink300.swiftUIColor
    static let pink200 = ChromaticAsset.pink200.swiftUIColor
    static let orange400 = ChromaticAsset.orange400.swiftUIColor
    static let purple400 = ChromaticAsset.purple400.swiftUIColor
}
