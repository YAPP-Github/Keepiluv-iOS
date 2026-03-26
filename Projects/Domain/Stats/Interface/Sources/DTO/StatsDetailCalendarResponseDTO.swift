//
//  StatsDetailCalendarResponseDTO.swift
//  DomainStatsInterface
//
//  Created by 정지훈 on 2/25/26.
//

import Foundation

public struct StatsDetailCalendarResponseDTO: Decodable {
    let goalId: Int64
    let goalName: String
    let goalIcon: String
    let yearMonth: String
    let isCompleted: Bool
    let completedDates: [CompletedDate]
    
    struct CompletedDate: Decodable {
        let date: String
        let myImageUrl: String?
        let partnerImageUrl: String?
    }
}

extension StatsDetailCalendarResponseDTO {
    public func toEntity() -> StatsDetail {
        StatsDetail(
            goalId: goalId,
            goalName: goalName,
            isCompleted: isCompleted,
            yearMonth: yearMonth,
            completedDate: completedDates.map {
                StatsDetail.CompletedDate(
                    date: $0.date,
                    myImageUrl: $0.myImageUrl,
                    partnerImageUrl: $0.partnerImageUrl
                )
            }
        )
    }
}
