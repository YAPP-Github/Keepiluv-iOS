//
//  GoalClient.swift
//  DomainGoalInterface
//
//  Created by 정지훈 on 1/26/26.
//

import Foundation

// TODO: - API 연동 후 Image -> Data로 바꿔 DesignSystem 의존성 떼기
import ComposableArchitecture
import SharedDesignSystem

/// 목표 목록을 조회하기 위한 Client입니다.
///
/// ## 사용 예시
/// ```swift
/// @Dependency(\.goalClient) var goalClient
/// let goals = try await goalClient.fetchGoals()
/// ```
public struct GoalClient {
    public var fetchGoals: () async throws -> [Goal]
    public var fetchGoalDetail: () async throws -> GoalDetail
    
    /// 목표 목록을 조회하는 클로저를 주입하여 GoalClient를 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let client = GoalClient(
    ///     fetchGoals: {
    ///         return []
    ///     }
    /// )
    /// ```
    public init(
        fetchGoals: @escaping () async throws -> [Goal],
        fetchGoalDetail: @escaping () async throws -> GoalDetail
    ) {
        self.fetchGoals = fetchGoals
        self.fetchGoalDetail = fetchGoalDetail
    }
}

extension GoalClient: TestDependencyKey {
    public static var testValue: GoalClient = Self(
        fetchGoals: {
            assertionFailure("GoalClient.fetchGoals이 구현되지 않았습니다. withDependencies로 mock을 주입하세요.")
            return []
        }, fetchGoalDetail: {
            assertionFailure("GoalClient.fetchGoalDetail이 구현되지 않았습니다. withDependencies로 mock을 주입하세요.")
            return .init(id: "error", title: "error", completedGoal: [])
        }
    )
    
    public static var previewValue: GoalClient = Self(
        fetchGoals: {
            return [
                Goal(
                    id: "1",
                    goalIcon: .Icon.Illustration.exercise,
                    title: "목표 1111111",
                    isCompleted: true,
                    image: SharedDesignSystemAsset.ImageAssets.boy.swiftUIImage,
                    emoji: .Icon.Illustration.emoji1
                ),
                Goal(
                    id: "2",
                    goalIcon: .Icon.Illustration.book,
                    title: "목표 2222222",
                    isCompleted: true,
                    image: SharedDesignSystemAsset.ImageAssets.boy.swiftUIImage
                ),
                Goal(
                    id: "3",
                    goalIcon: .Icon.Illustration.clean,
                    title: "목표 3333333",
                    isCompleted: false,
                    emoji: .Icon.Illustration.emoji1
                ),
                Goal(
                    id: "4",
                    goalIcon: .Icon.Illustration.default,
                    title: "목표 4444444",
                    isCompleted: false
                )
            ]
        },
        fetchGoalDetail: {
            return
                .init(
                    id: "1",
                    title: "아이스크림 먹기",
                    completedGoal: [
                        .init(
                            owner: .mySelf,
                            image: SharedDesignSystemAsset.ImageAssets.boy.swiftUIImage,
                            comment: "코멘트내용",
                            createdAt: "6시간 전"
                        ),
                        .init(
                            owner: .mySelf,
                            image: SharedDesignSystemAsset.ImageAssets.girl.swiftUIImage,
                            comment: "코멘트내용",
                            createdAt: "6시간 전"
                        )
                    ],
                    selectedIndex: 3
                )
        }
    )
}

extension DependencyValues {
    public var goalClient: GoalClient {
        get { self[GoalClient.self] }
        set { self[GoalClient.self] = newValue }
    }
}
