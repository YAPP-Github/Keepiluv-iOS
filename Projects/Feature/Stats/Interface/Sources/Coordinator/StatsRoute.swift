//
//  StatsRoute.swift
//  FeatureStats
//
//  Created by 정지훈 on 2/19/26.
//

import Foundation

/// Stats Coordinator에서 사용하는 Navigation 목적지입니다.
///
/// ## 사용 예시
/// ```swift
/// var routes: [StatsRoute] = []
/// routes.append(.detail)
/// ```
public enum StatsRoute: Equatable, Hashable {
    case statsDetail
    case goalDetail
}
