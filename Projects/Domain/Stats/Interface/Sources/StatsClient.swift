//
//  StatsClient.swift
//  DomainStatsInterface
//
//  Created by 정지훈 on 2/18/26.
//

import Foundation

import ComposableArchitecture
import CoreNetworkInterface

/// 통계 데이터 조회 API를 추상화한 클라이언트입니다.
///
/// 진행 중 통계와 완료된 통계를 비동기로 조회하는 기능을 제공합니다.
///
/// ## 사용 예시
/// ```swift
/// @Dependency(\.statsClient) var statsClient
/// let ongoing = try await statsClient.fetchStats("2026-02")
/// let completed = try await statsClient.fetchCompletedStats("2026-02")
/// ```
public struct StatsClient {
    /// 목표 통계를 조회합니다.
    public var fetchStats: (String, Bool) async throws -> Stats
    /// 단일 목표의 상세 통계를 조회합니다.
    public var fetchStatsDetailCalendar: (Int64, String) async throws -> StatsDetail
    public var fetchStatsDetailSummary: (Int64) async throws -> StatsDetail.Summary
    
    /// 통계 조회 동작을 주입해 `StatsClient`를 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let client = StatsClient(
    ///     fetchStats: { _ in Stats(myNickname: "", partnerNickname: "", stats: []) },
    ///     fetchStatsDetail: { _ in
    ///         StatsDetail(
    ///             goalId: 1,
    ///             goalName: "목표",
    ///             isCompleted: false,
    ///             completedDate: [],
    ///             summary: .init(
    ///                 myNickname: "",
    ///                 partnerNickname: "",
    ///                 totalCount: 0,
    ///                 myCompletedCount: 0,
    ///                 partnerCompltedCount: 0,
    ///                 repeatCycle: .daily,
    ///                 startDate: "",
    ///                 endDate: nil
    ///             )
    ///         )
    ///     }
    /// )
    /// ```
    public init(
        fetchStats: @escaping (String, Bool) async throws -> Stats,
        fetchStatsDetailCalendar: @escaping (Int64, String) async throws -> StatsDetail,
        fetchStatsDetailSummary: @escaping (Int64) async throws -> StatsDetail.Summary
    ) {
        self.fetchStats = fetchStats
        self.fetchStatsDetailCalendar = fetchStatsDetailCalendar
        self.fetchStatsDetailSummary = fetchStatsDetailSummary
    }
}

extension StatsClient: TestDependencyKey {
    public static var testValue: StatsClient = Self(
        fetchStats: { date, _ in
            assertionFailure("StatsClient.fetchStats이 구현되지 않았습니다. withDependencies로 mock을 주입하세요.")
            return Stats(
                myNickname: "현수",
                partnerNickname: "민정",
                stats: []
            )
        },
        fetchStatsDetailCalendar: { _, _ in
            assertionFailure("StatsClient.fetchStatsDetailCalendar이 구현되지 않았습니다. withDependencies로 mock을 주입하세요.")
            throw NetworkError.invalidResponseError
        },
        fetchStatsDetailSummary: { _ in
            assertionFailure("StatsClient.fetchStatsDetailSummary이 구현되지 않았습니다. withDependencies로 mock을 주입하세요.")
            throw NetworkError.invalidResponseError
        }
    )
    public static var previewValue: StatsClient = Self(
        fetchStats: { date, _ in
            return Stats(
                myNickname: "현수",
                partnerNickname: "민정",
                stats: [
                    .init(
                        goalId: 1,
                        icon: "ICON_BOOK",
                        goalName: "독서하기",
                        monthlyCount: 12,
                        totalCount: nil,
                        stamp: "CLOVER",
                        myStamp: .init(
                            completedCount: 5,
                            stampColors: [
                                .pink200, .orange400, .purple400
                            ]
                        ),
                        partnerStamp: .init(
                            completedCount: 2,
                            stampColors: [
                                .green400, .orange400, .yellow400
                            ]
                        )
                    ),
                    .init(
                        goalId: 2,
                        icon: "ICON_DEFUALT",
                        goalName: "요리 해먹기",
                        monthlyCount: 31,
                        totalCount: nil,
                        stamp: "FLOWER",
                        myStamp: .init(
                            completedCount: 2,
                            stampColors: [
                                .pink400, .orange400, .blue400
                            ]
                        ),
                        partnerStamp: .init(
                            completedCount: 11,
                            stampColors: [
                                .green400, .blue400, .yellow400
                            ]
                        )
                    ),
                    .init(
                        goalId: 3,
                        icon: "ICON_HEALTH",
                        goalName: "운동하기",
                        monthlyCount: 31,
                        totalCount: nil,
                        stamp: "MOON",
                        myStamp: .init(
                            completedCount: 25,
                            stampColors: [
                                .pink200, .orange400, .purple400
                            ]
                        ),
                        partnerStamp: .init(
                            completedCount: 12,
                            stampColors: [
                                .green400, .orange400, .yellow400
                            ]
                        )
                    ),
                    .init(
                        goalId: 4,
                        icon: "ICON_DEFAULT",
                        goalName: "난나난나",
                        monthlyCount: 15,
                        totalCount: nil,
                        stamp: "CLOVER",
                        myStamp: .init(
                            completedCount: 13,
                            stampColors: [
                                .pink300, .orange400, .purple400
                            ]
                        ),
                        partnerStamp: .init(
                            completedCount: 15,
                            stampColors: [
                                .green400, .orange400, .blue400
                            ]
                        )
                    ),
                ]
            )
        },
        fetchStatsDetailCalendar: { _, _ in
            return .init(
                goalId: 1,
                goalName: "밥 잘 챙겨먹기",
                isCompleted: false,
                yearMonth: "2026-02",
                completedDate: [
                    .init(
                        date: "2026-02-01",
                        myImageUrl: "",
                        partnerImageUrl: nil
                    ),
                    .init(
                        date: "2026-02-07",
                        myImageUrl: nil,
                        partnerImageUrl: ""
                    ),
                    .init(
                        date: "2026-02-14",
                        myImageUrl: "",
                        partnerImageUrl: ""
                    )
                ]
            )
        },
        fetchStatsDetailSummary: { _ in
            return .init(
                myNickname: "현수",
                partnerNickname: "민정",
                totalCount: 322,
                myCompletedCount: 82,
                partnerCompltedCount: 211,
                repeatCycle: .daily,
                startDate: "2026-01-07",
                endDate: "2027-01-07"
            )
        }
    )
}

extension DependencyValues {
    /// 통계 조회 클라이언트 의존성입니다.
    public var statsClient: StatsClient {
        get { self[StatsClient.self] }
        set { self[StatsClient.self] = newValue }
    }
}
