//
//  StatsEndpoint.swift
//  DomainStats
//
//  Created by 정지훈 on 2/25/26.
//

import Foundation

import CoreNetworkInterface

/// 통계 목록 조회 API 엔드포인트를 정의합니다.
public enum StatsEndpoint: Endpoint {
    case fetchStats(selectedDate: String, status: String)
}

extension StatsEndpoint {
    public var path: String {
        switch self {
        case .fetchStats:
            return "/api/v1/stats"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .fetchStats:
            return .get
        }
    }
    
    public var headers: [String : String]? {
        ["Content-Type": "application/json"]
    }
    
    public var query: [URLQueryItem]? {
        switch self {
        case let .fetchStats(date, status):
            return [
                .init(name: "selectedDate", value: date),
                .init(name: "status", value: status),
            ]
        }
    }
    
    public var body: (any Encodable)? {
        switch self {
        case .fetchStats:
            return nil
        }
    }
    
    public var requiresAuth: Bool { true }
    public var featureTag: FeatureTag { .stats }
}
