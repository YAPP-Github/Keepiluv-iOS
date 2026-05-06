//
//  AnalyticsEvent.swift
//  CoreAnalyticsInterface
//
//  Created by 정지훈 on 5/3/26.
//

import Foundation

public enum AnalyticsEvent {
    case onboarding(Onboarding)
    case goal(Goal)

    public var name: String {
        switch self {
        case .onboarding(let onboarding):
            return onboarding.name
        case .goal(let goal):
            return goal.name
        }
    }
}

// MARK: - Onboarding
public extension AnalyticsEvent {
    enum Onboarding {
        public var name: String {
            switch self {
            }
        }
    }
}

// MARK: - Goal
public extension AnalyticsEvent {
    enum Goal {
        public var name: String {
            switch self {
            }
        }
    }
}
