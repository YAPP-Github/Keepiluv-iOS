//
//  GoalEndpoint.swift
//  DomainGoal
//
//  Created by 정지훈 on 2/6/26.
//

import Foundation

import CoreNetworkInterface

/// 목표 관련 API 엔드포인트 정의입니다.
public enum GoalEndpoint: Endpoint {
    case fetchGoalList(date: String)
    case createGoal(GoalCreateRequestDTO)
    case fetchGoalDetail(goalId: Int)
}
    
extension GoalEndpoint {
    public var path: String {
        switch self {
        case .fetchGoalList: return "/api/v1/goals"
        case .createGoal: return "/api/v1/goals"
        case let .fetchGoalDetail(goalId):
            return "/api/v1/photologs/goals/\(goalId)"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .fetchGoalList:
            return .get
            
        case .createGoal:
            return .post

        case .fetchGoalDetail:
            return .get
        }
    }
    
    public var headers: [String : String]? {
        ["Content-Type": "application/json"]
    }
    
    public var query: [URLQueryItem]? {
        switch self {
        case let .fetchGoalList(date):
            return [URLQueryItem(name: "date", value: date)]
            
        case .createGoal:
            return nil

        case .fetchGoalDetail:
            return nil
        }
    }
    
    public var body: (any Encodable)? {
        switch self {
        case .fetchGoalList:
            return nil
            
        case let .createGoal(request):
            return request

        case .fetchGoalDetail:
            return nil
        }
    }
    
    public var requiresAuth: Bool { true }
    public var featureTag: FeatureTag { .goal }
}
