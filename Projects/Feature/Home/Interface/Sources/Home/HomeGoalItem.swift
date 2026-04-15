//
//  HomeGoalItem.swift
//  FeatureHomeInterface
//
//  Created by Codex on 4/10/26.
//

import Foundation

import DomainGoalInterface
import SharedDesignSystem

public struct HomeGoalItem: Equatable, Identifiable {
    public let id: Int64
    public var goal: Goal
    public var card: GoalCardItem

    public init(goal: Goal) {
        self.id = goal.id
        self.goal = goal
        self.card = Self.makeCard(from: goal)
    }
    
    public mutating func updateGoal(_ goal: Goal) {
        self.goal = goal
        self.card = Self.makeCard(from: goal)
    }

    private static func makeCard(from goal: Goal) -> GoalCardItem {
        let myImageURL = goal.myVerification?.imageURL.flatMap(URL.init(string:))
        let yourImageURL = goal.yourVerification?.imageURL.flatMap(URL.init(string:))

        return GoalCardItem(
            id: goal.id,
            goalName: goal.title,
            goalEmoji: GoalIcon(from: goal.goalIcon).image,
            myCard: .init(
                photologId: goal.myVerification?.photologId,
                imageURL: myImageURL,
                isSelected: goal.myVerification?.isCompleted ?? false,
                emoji: goal.myVerification?.emoji.flatMap { ReactionEmoji(from: $0)?.image }
            ),
            yourCard: .init(
                photologId: goal.yourVerification?.photologId,
                imageURL: yourImageURL,
                isSelected: goal.yourVerification?.isCompleted ?? false,
                emoji: goal.yourVerification?.emoji.flatMap { ReactionEmoji(from: $0)?.image }
            )
        )
    }
}
