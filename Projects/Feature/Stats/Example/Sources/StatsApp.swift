//
//  StatsView.swift
//
//
//  Created by Jihun on 02/18/26.
//

import SwiftUI

import ComposableArchitecture
import DomainStats
import DomainStatsInterface
import FeatureGoalDetail
import FeatureGoalDetailInterface
import FeatureMakeGoal
import FeatureMakeGoalInterface
import FeatureStats
import FeatureStatsInterface
import FeatureProofPhoto
import FeatureProofPhotoInterface

@main
struct StatsApp: App {
    var body: some Scene {
        WindowGroup {
            StatsCoordinatorView(
                store: Store(
                    initialState: StatsCoordinator.State(),
                    reducer: {
                        StatsCoordinator(
                            statsReducer: StatsReducer(),
                            statsDetailReducer: StatsDetailReducer(),
                            goalDetailReducer: GoalDetailReducer(
                                proofPhotoReducer: ProofPhotoReducer()
                            ),
                            makeGoalReducer: MakeGoalReducer()
                        )
                    },
                    withDependencies: {
                        $0.statsClient = .previewValue
                        $0.goalDetailFactory = .liveValue
                        $0.makeGoalFactory = .liveValue
                        $0.goalClient = .previewValue
                    }
                )
            )
        }
    }
}
