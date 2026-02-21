//
//  StatsDetail.swift
//  DomainStatsInterface
//
//  Created by 정지훈 on 2/20/26.
//

import Foundation

/// 통계 상세 화면에서 사용하는 목표 상세 정보 모델입니다.
///
/// 목표 기본 정보, 날짜별 완료 정보, 요약 정보를 함께 제공합니다.
public struct StatsDetail: Equatable {
    public let goalId: Int64
    public let goalName: String
    public var isCompleted: Bool
    public let completedDate: [CompletedDate]
    
    public let summary: Summary
    
    /// 날짜별 목표 달성 이미지를 나타내는 모델입니다.
    public struct CompletedDate: Equatable {
        public let date: String
        public let myImageUrl: String?
        public let partnerImageUrl: String?
    }
    
    /// 목표 달성 요약 정보를 나타내는 모델입니다.
    public struct Summary: Equatable {
        public let myNickname: String
        public let partnerNickname: String
        public let totalCount: Int
        public let myCompletedCount: Int
        public let partnerCompltedCount: Int
        public let repeatCycle: Stats.RepeatCycle
        public let startDate: String
        public let endDate: String?
    }
}
