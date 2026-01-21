//
//  TXTopAppBar+Action.swift
//  SharedDesignSystem
//
//  Created by 정지용 on 1/21/26.
//

import Foundation

extension TXTopAppBar {
    /// TopAppBar에서 발생할 수 있는 액션을 정의합니다.
    public enum Action: Equatable {
        case subTitleTapped
        case refreshTapped
        case alertTapped
        case settingTapped
        case backTapped
        case closeTapped
    }
}
