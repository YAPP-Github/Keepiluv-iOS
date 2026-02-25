//
//  HomeRoute.swift
//  FeatureHomeInterface
//
//  Created by 정지훈 on 1/27/26.
//

import Foundation

/// Home Feature에서 사용하는 라우팅 목적지입니다.
public enum HomeRoute: Equatable, Hashable {
    case editGoalList
    case detail
    case statsDetail
    case makeGoal
    case settings
    case settingsAccount
    case settingsInfo
    case settingsNotificationSettings
    case settingsWebView(url: URL, title: String)
    case notification
}
