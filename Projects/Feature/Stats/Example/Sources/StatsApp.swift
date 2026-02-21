//
//  StatsView.swift
//
//
//  Created by Jihun on 02/18/26.
//

import SwiftUI

import ComposableArchitecture
import DomainStatsInterface
import FeatureStats
import FeatureStatsInterface

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
                            statsDetailReducer: StatsDetailReducer()
                        )
                    },
                    withDependencies: {
                        $0.statsClient = .testValue
                    }
                )
            )
        }
    }
}
