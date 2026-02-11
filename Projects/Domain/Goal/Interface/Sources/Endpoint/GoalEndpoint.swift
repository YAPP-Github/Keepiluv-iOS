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
    case fetchGoalDetailList(date: String)
    case fetchGoalById(goalId: Int64)
    case fetchGoalEditList(date: String)
    case updateGoal(goalId: Int64, GoalUpdateRequestDTO)
    case deleteGoal(goalId: Int64)
    case completeGoal(goalId: Int64)
}
    
extension GoalEndpoint {
    public var path: String {
        switch self {
        case .fetchGoalList: return "/api/v1/goals"

        case .createGoal: return "/api/v1/goals"

        case .fetchGoalDetailList:
            return "/api/v1/photologs"

        case let .fetchGoalById(goalId):
            return "/api/v1/goals/\(goalId)"
            
        case .fetchGoalEditList:
            return "/api/v1/goals/detail"

        case let .updateGoal(goalId, _):
            return "/api/v1/goals/\(goalId)"

        case let .deleteGoal(goalId):
            return "/api/v1/goals/\(goalId)"

        case let .completeGoal(goalId):
            return "/api/v1/goals/\(goalId)/complete"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .fetchGoalList:
            return .get

        case .createGoal:
            return .post

        case .fetchGoalDetailList:
            return .get

        case .fetchGoalById:
            return .get
            
        case .fetchGoalEditList:
            return .get

        case .updateGoal:
            return .put

        case .deleteGoal:
            return .delete

        case .completeGoal:
            return .patch
        }
    }
    
    public var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }
    
    public var query: [URLQueryItem]? {
        switch self {
        case let .fetchGoalList(date):
            return [URLQueryItem(name: "date", value: date)]
            
        case let .fetchGoalEditList(date):
            return [URLQueryItem(name: "date", value: date)]
            
        case let .fetchGoalDetailList(date):
            return [URLQueryItem(name: "targetDate", value: date)]

        case .createGoal,
             .fetchGoalById,
             .updateGoal,
             .deleteGoal,
             .completeGoal:
            return nil
        }
    }
    
    public var body: (any Encodable)? {
        switch self {
        case .fetchGoalList:
            return nil

        case let .createGoal(request):
            return request

        case .fetchGoalDetailList,
             .fetchGoalById,
             .fetchGoalEditList,
             .deleteGoal,
             .completeGoal:
            return nil

        case let .updateGoal(_, request):
            return request
        }
    }
    
    public var requiresAuth: Bool { true }
    public var featureTag: FeatureTag { .goal }
}
