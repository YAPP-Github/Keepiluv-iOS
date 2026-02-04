//
//  TXModalAction.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 2/4/26.
//

import Foundation

/// 모달에서 발생하는 기본 액션 타입입니다.
public enum TXModalAction: Equatable {
    case cancel
    case confirm
    case confirmWithIndex(Int)
}
