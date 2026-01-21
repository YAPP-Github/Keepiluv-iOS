//
//  TXTopTabBar+Configuration.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/20/26.
//

import SwiftUI

public extension TXTopTabBar.Configuration {
    static func goal(items: [String] = ["진행중", "종료"]) -> Self {
        .init(items: items)
    }
}
