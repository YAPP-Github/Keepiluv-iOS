//
//  GoalIcon.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 2/19/26.
//

import SwiftUI

public enum GoalIcon: String, Equatable, CaseIterable {
    case `default` = "ICON_DEFAULT"
    case clean = "ICON_CLEAN"
    case exercise = "ICON_EXERCISE"
    case book = "ICON_BOOK"
    case pencil = "ICON_PENCIL"
    case health = "ICON_HEALTH"
    case heartDouble = "ICON_HEART"
    case laptop = "ICON_LAPTOP"
}

public extension GoalIcon {
    init(from value: String) {
        self = GoalIcon(rawValue: value) ?? .default
    }
    
    var image: Image {
        switch self {
        case .default:
            return .Icon.Illustration.default
        case .clean:
            return .Icon.Illustration.clean
        case .exercise:
            return .Icon.Illustration.exercise
        case .book:
            return .Icon.Illustration.book
        case .pencil:
            return .Icon.Illustration.pencil
        case .health:
            return .Icon.Illustration.health
        case .heartDouble:
            return .Icon.Illustration.heartDouble
        case .laptop:
            return .Icon.Illustration.laptop
        }
    }
}
