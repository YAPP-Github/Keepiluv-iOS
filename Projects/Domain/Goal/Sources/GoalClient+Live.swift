//
//  GoalClient+Live.swift
//  DomainGoalInterface
//
//  Created by 정지훈 on 1/26/26.
//

import ComposableArchitecture
import CoreNetworkInterface
import DomainGoalInterface

extension GoalClient: @retroactive DependencyKey {
    public static let liveValue: GoalClient = .live()
    
    /// GoalClient의 기본 구현입니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// @Dependency(\.goalClient) var goalClient
    /// let goals = try await goalClient.fetchGoals("2026-02-06")
    /// ```
    static func live() -> GoalClient {
        @Dependency(\.networkClient) var networkClient
        
        return .init(
            fetchGoals: { date in
                do {
                    let response: GoalListResponseDTO = try await networkClient.request(
                        endpoint: GoalEndpoint.fetchGoalList(date: date)
                    )
                    return response.toEntity(response)
                } catch {
                    
                    throw error
                }
            },
            createGoal: { request in
                do {
                    let response: GoalCreateResponseDTO = try await networkClient.request(
                        endpoint: GoalEndpoint.createGoal(request)
                    )
                    return response.toEntity(response)
                } catch {

                    throw error
                }
            },
            fetchGoalDetail: {
                return GoalDetail(id: "", title: "", completedGoal: [])
            }
        )
    }
}
