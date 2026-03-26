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
    
    public init(from value: String) {
        self = Self(rawValue: value) ?? .default
    }
}

public extension GoalIcon {
    var image: Image {
        switch self {
        case .default: .Icon.Illustration.default
        case .clean: .Icon.Illustration.clean
        case .exercise: .Icon.Illustration.exercise
        case .book: .Icon.Illustration.book
        case .pencil: .Icon.Illustration.pencil
        case .health: .Icon.Illustration.health
        case .heartDouble: .Icon.Illustration.heartDouble
        case .laptop: .Icon.Illustration.laptop
        }
    }
}
