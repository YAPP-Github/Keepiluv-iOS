//
//  TXModalType+Configuration.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/27/26.
//

import SwiftUI

public extension TXModalType {
    func configuration(onConfirm: @escaping () -> Void) -> TXModalView.Configuration {
        switch self {
        case .deleteGoal:
            return .deleteGoal(onConfirm: onConfirm)
        }
    }
}
