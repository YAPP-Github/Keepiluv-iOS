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
        // MARK: - Home Style Actions
        /// 서브타이틀(날짜) 영역 탭
        case subTitleTapped
        /// 새로고침 버튼 탭
        case refreshTapped
        /// 알림 버튼 탭
        case alertTapped
        /// 설정 버튼 탭
        case settingTapped

        // MARK: - SubTitle Style Actions
        /// 뒤로가기 버튼 탭
        case backTapped
        /// 닫기 버튼 탭
        case closeTapped
    }
}
