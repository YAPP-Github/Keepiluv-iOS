//
//  AnalyticsEvent.swift
//  CoreAnalyticsInterface
//
//  Created by 정지훈 on 5/3/26.
//

import Foundation

/// 분석 도구로 전송할 이벤트가 따라야 하는 공통 인터페이스입니다.
///
/// ## 사용 예시
/// ```swift
/// enum HomeAnalyticsEvent: AnalyticsEvent {
///     case homeViewed
///
///     var name: String { "home_viewed" }
///     var parameters: [String: Any]? { nil }
/// }
/// ```
public protocol AnalyticsEvent {
    var name: String { get }
    var parameters: [String: Any]? { get }
}
