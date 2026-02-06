//
//  GoalReaction+Image.swift
//  FeatureHome
//
//  Created by Jihun on 2/6/26.
//

import SwiftUI

import DomainGoalInterface
import SharedDesignSystem

extension Goal.Reaction {
    var image: Image {
        switch self {
        case .happy:
            return .Icon.Illustration.happy
        case .trouble:
            return .Icon.Illustration.trouble
        case .love:
            return .Icon.Illustration.love
        case .doubt:
            return .Icon.Illustration.doubt
        case .fuck:
            return .Icon.Illustration.fuck
        case .heart:
            return .Icon.Illustration.heart
        }
    }
}
