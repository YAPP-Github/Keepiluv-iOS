//
//  GoalIcon+Image.swift
//  FeatureHome
//
//  Created by Codex on 2/6/26.
//

import SwiftUI

import DomainGoalInterface
import SharedDesignSystem

extension Goal.Icon {
    public var image: Image {
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
