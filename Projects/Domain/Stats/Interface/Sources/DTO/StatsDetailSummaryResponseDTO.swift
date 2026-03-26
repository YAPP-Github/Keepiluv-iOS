//
//  StatsDetailSummaryResponseDTO.swift
//  DomainStatsInterface
//
//  Created by 정지훈 on 2/25/26.
//

import Foundation

public struct StatsDetailSummaryResponseDTO: Decodable {
    let myNickname: String
    let partnerNickname: String
    let totalCount: Int
    let myCompletedCount: Int
    let partnerCompletedCount: Int
    let repeatCycle: String
    let startDate: String
    let endDate: String?
}

extension StatsDetailSummaryResponseDTO {
    public func toEntity() -> StatsDetail.Summary {
        return .init(
            myNickname: myNickname,
            partnerNickname: partnerNickname,
            totalCount: totalCount,
            myCompletedCount: myCompletedCount,
            partnerCompltedCount: partnerCompletedCount,
            repeatCycle: .init(rawValue: repeatCycle) ?? .daily,
            startDate: startDate,
            endDate: endDate
        )
    }
}
