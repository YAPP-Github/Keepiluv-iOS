//
//  StatsResponseDTO.swift
//  DomainStats
//
//  Created by 정지훈 on 2/25/26.
//

import CoreNetworkInterface

/// 통계 목록 조회 응답을 디코딩하는 DTO입니다.
public struct StatsResponseDTO: Decodable {
    let selectedDate: String
    let statsGoals: [StatsGoal]
    
    struct StatsGoal: Codable {
        let goalId: Int64
        let goalName: String
        let goalIconType: String
        let monthlyTargetCount: Int
        let stamp: String
        let myStats: Stats
        let partnerStats: Stats
        
        struct Stats: Codable {
            let nickname: String
            let endCount: Int
            let stampColors: [String]
        }
    }
}

extension StatsResponseDTO {
    /// 통계 목록 응답 DTO를 도메인 `Stats` 엔티티로 변환합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let dto: StatsResponseDTO = ...
    /// let stats = dto.toEntity(isInProgress: true)
    /// ```
    public func toEntity(isInProgress: Bool) -> Stats {
        guard let firstStats = statsGoals.first
        else {
            return .init(
                myNickname: "",
                partnerNickname: "",
                stats: []
            )
        }
        
        return Stats(
            myNickname: firstStats.myStats.nickname,
            partnerNickname: firstStats.partnerStats.nickname,
            stats: statsGoals.map {
                Stats.StatsItem(
                    goalId: $0.goalId,
                    icon: $0.goalIconType,
                    goalName: $0.goalName,
                    monthlyCount: $0.monthlyTargetCount,
                    totalCount: isInProgress ? nil : $0.monthlyTargetCount,
                    stamp: $0.stamp,
                    myStamp: .init(
                        completedCount: $0.myStats.endCount,
                        stampColors: isInProgress
                        ? $0.myStats.stampColors.compactMap { Stats.StatsItem.StampColor.init(rawValue: $0) }
                        : []
                    ),
                    partnerStamp: .init(
                        completedCount: $0.partnerStats.endCount,
                        stampColors: isInProgress
                        ? $0.partnerStats.stampColors.compactMap { Stats.StatsItem.StampColor.init(rawValue: $0) }
                        : []
                    )
                )
            }
        )
    }
}
