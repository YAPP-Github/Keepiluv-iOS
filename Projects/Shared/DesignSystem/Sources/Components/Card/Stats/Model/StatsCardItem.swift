//
//  StatsCardItem.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 2/19/26.
//

import SwiftUI

public struct StatsCardItem: Equatable {
    public let goalId: Int64
    public let goalName: String
    public let iconImage: Image
    public let goalCount: Int
    public let completionInfos: [CompletionInfo]
    
    public struct CompletionInfo: Equatable {
        public let name: String
        public let count: Int
        
        public init(
            name: String,
            count: Int
        ) {
            self.name = name
            self.count = count
        }
    }
    
    public init(
        goalId: Int64,
        goalName: String,
        iconImage: Image,
        goalCount: Int,
        completionInfos: [CompletionInfo]
    ) {
        self.goalId = goalId
        self.goalName = goalName
        self.iconImage = iconImage
        self.goalCount = goalCount
        self.completionInfos = completionInfos
    }
}
