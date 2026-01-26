//
//  GoalClient.swift
//  DomainGoalInterface
//
//  Created by 정지훈 on 1/26/26.
//

import Foundation

import ComposableArchitecture
import SharedDesignSystem

public struct GoalClient {
    public var fetchGoals: () async throws -> [Goal]
    
    public init(
        fetchGoals: @escaping () async throws -> [Goal]
    ) {
        self.fetchGoals = fetchGoals
    }
}

extension GoalClient: TestDependencyKey {
    public static var testValue: GoalClient = Self(
        fetchGoals: {
            assertionFailure("GoalClient.fetchGoals이 구현되지 않았습니다. withDependencies로 mock을 주입하세요.")
            return []
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
                    goalIcon: .Icon.Illustration.drug,
                    title: "목표 2222222",
                    isCompleted: true,
                    image: SharedDesignSystemAsset.ImageAssets.boy.swiftUIImage
                ),
                Goal(
                    id: "3",
                    goalIcon: .Icon.Illustration.fire,
                    title: "목표 3333333",
                    isCompleted: false,
                    emoji: .Icon.Illustration.emoji1
                ),
                Goal(
                    id: "4",
                    goalIcon: .Icon.Illustration.emojiAdd,
                    title: "목표 4444444",
                    isCompleted: false
                )
            ]
        }
    )
}

extension DependencyValues {
    public var goalClient: GoalClient {
        get { self[GoalClient.self] }
        set { self[GoalClient.self] = newValue }
    }
}
