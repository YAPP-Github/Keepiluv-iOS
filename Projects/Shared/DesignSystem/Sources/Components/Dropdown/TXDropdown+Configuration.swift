//
//  TXDropdown+Configuration.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/20/26.
//

import SwiftUI

public extension TXDropdown.Configuration {
    /// 목표 카드 메뉴용 기본 드롭다운 설정입니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// TXDropdown(config: .goal) { _ in }
    /// ```
    static var goal: Self { .init(items: [.edit, .finish, .delete]) }
}
