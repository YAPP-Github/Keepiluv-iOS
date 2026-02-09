//
//  RequestContext.swift
//  CoreNetworkInterface
//
//  Created by Jiyong on 2/9/26.
//

import Foundation

/// 네트워크 요청 컨텍스트를 담는 구조체입니다.
///
/// Interceptor가 요청을 수정하거나 재시도 결정을 내릴 때 사용됩니다.
public struct RequestContext: Sendable {
    /// 원본 엔드포인트 정보
    public let endpoint: Endpoint

    /// 실제 URLRequest (수정 가능)
    public var request: URLRequest

    public init(endpoint: Endpoint, request: URLRequest) {
        self.endpoint = endpoint
        self.request = request
    }
}
