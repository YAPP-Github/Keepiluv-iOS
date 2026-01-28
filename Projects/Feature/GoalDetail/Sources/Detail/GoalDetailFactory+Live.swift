//
//  GoalDetailFactory+Live.swift
//  FeatureGoalDetail
//
//  Created by 정지훈 on 1/28/26.
//

import SwiftUI

import ComposableArchitecture
import FeatureGoalDetailInterface

extension GoalDetailFactory: @retroactive DependencyKey {
    public static var liveValue: GoalDetailFactory = Self { store in
        AnyView(GoalDetailView(store: store))
    }
}
