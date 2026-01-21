//
//  TXDropdown+Configuration.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/20/26.
//

import SwiftUI

public extension TXDropdown.Configuration {
    static func goal(items: [String] = ["수정하기", "끝내기", "삭제하기"]) -> Self {
        .init(items: items)
    }
}
