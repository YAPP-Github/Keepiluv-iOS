//
//  AnalyticsEvent.swift
//  CoreAnalyticsInterface
//
//  Created by 정지훈 on 5/3/26.
//

import Foundation

public protocol AnalyticsEvent {
    var name: String { get }
    var parameters: [String: Any]? { get }
}
