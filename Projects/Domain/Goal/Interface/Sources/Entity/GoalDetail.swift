//
//  GoalDetail.swift
//  DomainGoalInterface
//
//  Created by 정지훈 on 1/28/26.
//

import SwiftUI

import SharedDesignSystem

// FIXME: - Image -> Data로 변환
public struct GoalDetail {
    public let id: String
    public let title: String
    public var selectedIndex: Int?
    public var completedGoal: [CompletedGoal]
    
    public init(
        id: String,
        title: String,
        selectedIndex: Int? = nil,
        completedGoal: [CompletedGoal]
    ) {
        self.id = id
        self.title = title
        self.selectedIndex = selectedIndex
        self.completedGoal = completedGoal
    }
    
    public struct CompletedGoal {
        public let owner: Owner
        public var image: Image?
        public let coment: String
        public let createdAt: String?
    }
    
    public enum Owner: String {
        case mySelf
        case you
    }
}
