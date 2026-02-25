//
//  StatsClient+Live.swift
//  DomainStats
//
//  Created by 정지훈 on 2/25/26.
//

import ComposableArchitecture
import CoreNetworkInterface
import DomainStatsInterface

extension StatsClient: @retroactive DependencyKey {
    public static let liveValue: StatsClient = live()
    
    private static func live() -> StatsClient {
        @Dependency(\.networkClient) var networkClient
        
        return StatsClient(
            fetchOngoingStats: { date in
                do {
                    let response: StatsResponseDTO = try await networkClient.request(
                        endpoint: StatsEndpoint.fetchStats(selectedDate: date, status: "IN_PROGRESS")
                    )
                    
                    guard let stats = response.toEntity(isInProgress: true)
                    else { throw NetworkError.invalidResponseError }
                    
                    return stats
                } catch {
                    throw error
                }
            },
            fetchCompletedStats: { _ in
                // FIXME: - API 연동
                throw NetworkError.notFoundError
            },
            fetchStatsDetail: { _ in
                // FIXME: - API 연동
                throw NetworkError.notFoundError
            }
        )
    }
}
