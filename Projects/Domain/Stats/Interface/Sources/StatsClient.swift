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
/// let ongoing = try await statsClient.fetchOngoingStats("2026-02")
/// let completed = try await statsClient.fetchCompletedStats("2026-02")
/// ```
public struct StatsClient {
    /// 진행 중 목표 통계를 조회합니다.
    public var fetchOngoingStats: (String) async throws -> Stats
    /// 완료된 목표 통계를 조회합니다.
    public var fetchCompletedStats: (String) async throws -> Stats
    /// 단일 목표의 상세 통계를 조회합니다.
    public var fetchStatsDetail: (String) async throws -> StatsDetail
    
    /// 통계 조회 동작을 주입해 `StatsClient`를 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let client = StatsClient(
    ///     fetchOngoingStats: { _ in Stats(myNickname: "", partnerNickname: "", stats: []) },
    ///     fetchCompletedStats: { _ in Stats(myNickname: "", partnerNickname: "", stats: []) },
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
        fetchOngoingStats: @escaping (String) async throws -> Stats,
        fetchCompletedStats: @escaping (String) async throws -> Stats,
        fetchStatsDetail: @escaping (String) async throws -> StatsDetail,
    ) {
        self.fetchOngoingStats = fetchOngoingStats
        self.fetchCompletedStats = fetchCompletedStats
        self.fetchStatsDetail = fetchStatsDetail
    }
}

// TODO: - API 연동
extension StatsClient: TestDependencyKey {
    public static var testValue: StatsClient = Self(
        fetchOngoingStats: { date in
            //            assertionFailure("StatsClient.fetchOngoingStats이 구현되지 않았습니다. withDependencies로 mock을 주입하세요.")
            //            return []
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
                        myCompletedCount: 6,
                        partnerCompletedCount: 2
                    ),
                    .init(
                        goalId: 2,
                        icon: "ICON_DEFUALT",
                        goalName: "요리 해먹기",
                        monthlyCount: 17,
                        totalCount: nil,
                        myCompletedCount: 12,
                        partnerCompletedCount: 8
                    ),
                    .init(
                        goalId: 3,
                        icon: "ICON_HEALTH",
                        goalName: "운동하기",
                        monthlyCount: 31,
                        totalCount: nil,
                        myCompletedCount: 2,
                        partnerCompletedCount: 11
                    ),
                    .init(
                        goalId: 4,
                        icon: "ICON_DEFAULT",
                        goalName: "난나난나",
                        monthlyCount: 15,
                        totalCount: nil,
                        myCompletedCount: 13,
                        partnerCompletedCount: 15
                    ),
                ]
            )
        },
        fetchCompletedStats: { _ in
            //            assertionFailure("StatsClient.fetchCompletedStats이 구현되지 않았습니다. withDependencies로 mock을 주입하세요.")
            //            return []
            return Stats(
                myNickname: "현수",
                partnerNickname: "민정",
                stats: [
                    .init(
                        goalId: 6,
                        icon: "ICON_BOOK",
                        goalName: "독서하기",
                        monthlyCount: nil,
                        totalCount: 232,
                        myCompletedCount: 221,
                        partnerCompletedCount: 187
                    ),
                    .init(
                        goalId: 7,
                        icon: "ICON_DEFUALT",
                        goalName: "요리 해먹기",
                        monthlyCount: nil,
                        totalCount: 68,
                        myCompletedCount: 23,
                        partnerCompletedCount: 62
                    ),
                    .init(
                        goalId: 8,
                        icon: "ICON_HEALTH",
                        goalName: "운동하기",
                        monthlyCount: nil,
                        totalCount: 5,
                        myCompletedCount: 5,
                        partnerCompletedCount: 5
                    ),
                    .init(
                        goalId: 9,
                        icon: "ICON_DEFAULT",
                        goalName: "난나난나",
                        monthlyCount: nil,
                        totalCount: 300,
                        myCompletedCount: 102,
                        partnerCompletedCount: 203
                    ),
                ]
            )
        },
        fetchStatsDetail: { _ in
            //             assertionFailure("StatsClient.fetchStatsDetail이 구현되지 않았습니다. withDependencies로 mock을 주입하세요.")
            //
            return .init(
                goalId: 1,
                goalName: "밥 잘 챙겨먹기",
                isCompleted: true,
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
                ],
                summary: .init(
                    myNickname: "현수",
                    partnerNickname: "민정",
                    totalCount: 322,
                    myCompletedCount: 82,
                    partnerCompltedCount: 211,
                    repeatCycle: .daily,
                    startDate: "2026년 1월 7일",
                    endDate: "2027년 1월 7일"
                )
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
