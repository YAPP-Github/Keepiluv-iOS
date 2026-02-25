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
            fetchStats: { date, isInProgress in
                do {
                    let status = isInProgress ? "IN_PROGRESS" : "COMPLETED"
                    let response: StatsResponseDTO = try await networkClient.request(
                        endpoint: StatsEndpoint.fetchStats(selectedDate: date, status: status)
                    )
                    
                    return response.toEntity(isInProgress: isInProgress)
                } catch {
                    throw error
                }
            },
            fetchStatsDetail: { _ in
                // FIXME: - API 연동
                throw NetworkError.notFoundError
            }
        )
    }
}
