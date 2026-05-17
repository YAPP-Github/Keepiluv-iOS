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
import Foundation
import SharedPerfTestingSupport

@main
struct StatsApp: App {
    init() {
        UITestMode.configureApplication()
    }

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
                        $0.statsClient = StatsApp.statsClient(for: UITestMode.seedName)
                        $0.goalDetailFactory = .liveValue
                        $0.makeGoalFactory = .liveValue
                        $0.goalClient = .previewValue
                    }
                )
            )
            .perfRoot("stats")
            .perfReadyMarker("stats")
        }
    }
}

private extension StatsApp {
    static func statsClient(for seed: String) -> StatsClient {
        guard UITestMode.isEnabled, seed == "scroll-50" else {
            return .previewValue
        }
        var client = StatsClient.previewValue
        client.fetchStats = { _, _ in
            Stats(
                myNickname: "현수",
                partnerNickname: "민정",
                stats: (1...50).map { index in
                    Stats.StatsItem(
                        goalId: Int64(index),
                        icon: index.isMultiple(of: 2) ? "ICON_BOOK" : "ICON_HEALTH",
                        goalName: "Perf scroll item #\(index)",
                        monthlyCount: index % 30,
                        totalCount: nil,
                        stamp: index.isMultiple(of: 3) ? "CLOVER" : "FLOWER",
                        myStamp: .init(
                            completedCount: index % 12,
                            stampColors: [.pink200, .orange400, .purple400]
                        ),
                        partnerStamp: .init(
                            completedCount: index % 9,
                            stampColors: [.green400, .orange400, .yellow400]
                        )
                    )
                }
            )
        }
        return client
    }
}
