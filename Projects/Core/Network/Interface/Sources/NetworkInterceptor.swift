//
//  NetworkInterceptor.swift
//  CoreNetworkInterface
//
//  Created by Jiyong
//

import Foundation

/// 네트워크 요청의 생명주기를 intercept하여 로깅, 모니터링 등의 작업을 수행하는 프로토콜
public protocol NetworkInterceptor: Sendable {
    /// URLSessionTask가 생성될 때 호출됩니다.
    /// - Parameter task: 생성된 URLSessionTask
    func didCreateTask(_ task: URLSessionTask)

    /// URLSessionDataTask가 데이터를 수신했을 때 호출됩니다.
    /// - Parameters:
    ///   - task: 데이터를 수신한 URLSessionDataTask
    ///   - data: 수신한 데이터
    func didReceiveData(_ task: URLSessionDataTask, data: Data)

    /// URLSessionTask가 완료되었을 때 호출됩니다.
    /// - Parameters:
    ///   - task: 완료된 URLSessionTask
    ///   - error: 에러가 발생한 경우 전달되는 Error 객체 (성공 시 nil)
    func didCompleteTask(_ task: URLSessionTask, error: Error?)
}
