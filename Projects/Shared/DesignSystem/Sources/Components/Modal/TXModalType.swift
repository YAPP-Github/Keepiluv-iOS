//
//  TXModalType.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/27/26.
//

import Foundation

/// 모달 UI에서 사용할 수 있는 유형을 정의합니다.
public enum TXModalType: Equatable {
    case info(TXInfoModalContent.Configuration)
    case gridButton
}

extension TXModalType: Identifiable {
    public var id: String {
        switch self {
        case .info:
            return "info"
        case .gridButton:
            return "gridButton"
        }
    }
}
