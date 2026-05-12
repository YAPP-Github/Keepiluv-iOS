//
//  AnalyticsUserProfile.swift
//  CoreAnalyticsInterface
//
//  Created by 정지훈 on 5/12/26.
//

import Foundation

public struct AnalyticsUserProfile {
    public let id: Int64
    public let name: String
    
    public init(id: Int64, name: String) {
        self.id = id
        self.name = name
    }
}
