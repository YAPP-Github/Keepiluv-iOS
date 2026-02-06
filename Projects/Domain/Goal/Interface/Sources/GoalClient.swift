//
//  GoalClient.swift
//  DomainGoalInterface
//
//  Created by 정지훈 on 1/26/26.
//

import Foundation

import ComposableArchitecture
import CoreNetworkInterface

/// 목표 정보를 조회하기 위한 Client입니다.
///
/// ## 사용 예시
/// ```swift
/// @Dependency(\.goalClient) var goalClient
/// let goals = try await goalClient.fetchGoals("2026-02-06")
/// ```
public struct GoalClient {
    public var fetchGoals: (String) async throws -> [Goal]
    public var createGoal: (GoalCreateRequestDTO) async throws -> Goal
    public var fetchGoalDetail: () async throws -> GoalDetail
    
    /// 목표 조회 클로저를 주입하여 GoalClient를 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let client = GoalClient(
    ///     fetchGoals: { _ in
    ///         return []
    ///     }
    /// )
    /// ```
    public init(
        fetchGoals: @escaping (String) async throws -> [Goal],
        createGoal: @escaping (GoalCreateRequestDTO) async throws -> Goal,
        fetchGoalDetail: @escaping () async throws -> GoalDetail
    ) {
        self.fetchGoals = fetchGoals
        self.createGoal = createGoal
        self.fetchGoalDetail = fetchGoalDetail
    }
}

extension GoalClient: TestDependencyKey {
    public static var testValue: GoalClient = Self(
        fetchGoals: { _ in
            assertionFailure("GoalClient.fetchGoals이 구현되지 않았습니다. withDependencies로 mock을 주입하세요.")
            return []
        },
        createGoal: { _ in
            assertionFailure("GoalClient.createGoal이 구현되지 않았습니다. withDependencies로 mock을 주입하세요.")
            let trashVerification = Goal.Verification(
                isCompleted: false,
                imageURL: nil,
                emoji: nil
            )
            
            return .init(
                id: 1,
                goalIcon: .default,
                title: "",
                myVerification: trashVerification,
                yourVerification: trashVerification
            )
        },
        fetchGoalDetail: {
            assertionFailure("GoalClient.fetchGoalDetail이 구현되지 않았습니다. withDependencies로 mock을 주입하세요.")
            return .init(id: "error", title: "error", completedGoal: [])
        }
    )
    
//    public static var previewValue: GoalClient = Self(
//        fetchGoals: { _ in
//            return [
//                Goal(
//                    id: "1",
//                    goalIcon: .Icon.Illustration.exercise,
//                    title: "목표 1111111",
//                    isCompleted: true,
//                    image: SharedDesignSystemAsset.ImageAssets.boy.swiftUIImage,
//                    emoji: .Icon.Illustration.doubt
//                ),
//                Goal(
//                    id: "2",
//                    goalIcon: .Icon.Illustration.book,
//                    title: "목표 2222222",
//                    isCompleted: true,
//                    image: SharedDesignSystemAsset.ImageAssets.boy.swiftUIImage
//                ),
//                Goal(
//                    id: "3",
//                    goalIcon: .Icon.Illustration.clean,
//                    title: "목표 3333333",
//                    isCompleted: false,
//                    emoji: .Icon.Illustration.fuck
//                ),
//                Goal(
//                    id: "4",
//                    goalIcon: .Icon.Illustration.default,
//                    title: "목표 4444444",
//                    isCompleted: false
//                )
//            ]
//        },
//        fetchGoalDetail: {
//            return
//                .init(
//                    id: "1",
//                    title: "아이스크림 먹기",
//                    completedGoal: [
//                        .init(
//                            owner: .mySelf,
//                            image: SharedDesignSystemAsset.ImageAssets.boy.swiftUIImage,
//                            comment: "코멘트내용",
//                            createdAt: "6시간 전"
//                        ),
//                        .init(
//                            owner: .mySelf,
//                            image: SharedDesignSystemAsset.ImageAssets.girl.swiftUIImage,
//                            comment: "코멘트내용",
//                            createdAt: "6시간 전"
//                        )
//                    ],
//                    selectedIndex: 3
//                )
//        }
//    )
}

extension DependencyValues {
    public var goalClient: GoalClient {
        get { self[GoalClient.self] }
        set { self[GoalClient.self] = newValue }
    }
}
