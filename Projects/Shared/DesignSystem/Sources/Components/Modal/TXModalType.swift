//
//  TXModalType.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/27/26.
//

import Foundation

public enum TXModalType: Equatable, Identifiable {
    case deleteGoal

    public var id: String {
        switch self {
        case .deleteGoal:
            return "deleteGoal"
        }
    }
}
