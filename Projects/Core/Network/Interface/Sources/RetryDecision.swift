//
//  RetryDecision.swift
//  CoreNetworkInterface
//
//  Created by Jiyong on 2/9/26.
//

import Foundation

/// 네트워크 요청 실패 시 재시도 여부를 결정하는 열거형입니다.
public enum RetryDecision: Sendable {
    /// 재시도하지 않습니다.
    case doNotRetry

    /// 수정된 URLRequest로 재시도합니다.
    case retry(URLRequest)
}
