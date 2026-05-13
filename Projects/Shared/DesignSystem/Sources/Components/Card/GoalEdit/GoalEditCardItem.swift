//
//  GoalEditCardItem.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/21/26.
//

import SwiftUI

public struct GoalEditCardItem: Identifiable, Equatable {
    public let id: Int64
    public let goalName: String
    public let goalIcon: GoalIcon?
    public let iconImage: Image
    public let repeatCycle: String
    public let startDate: String
    public let endDate: String
    
    public init(
        id: Int64,
        goalName: String,
        goalIcon: GoalIcon? = nil,
        iconImage: Image,
        repeatCycle: String,
        startDate: String,
        endDate: String
    ) {
        self.id = id
        self.goalName = goalName
        self.goalIcon = goalIcon
        self.iconImage = iconImage
        self.repeatCycle = repeatCycle
        self.startDate = startDate
        self.endDate = endDate
    }
}
