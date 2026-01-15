//
//  PulseNetworkInterceptor.swift
//  CoreLogging
//
//  Created by Jiyong
//

#if DEBUG
import CoreNetworkInterface
import Foundation
import Pulse

/// Pulse를 사용하여 네트워크 요청을 로깅하는 Interceptor (DEBUG 전용)
public final class PulseNetworkInterceptor: NetworkInterceptor {
    private let labelLogger: NetworkLogger
    private let globalLogger: NetworkLogger

    /// PulseNetworkInterceptor를 생성합니다.
    /// - Parameter label: Feature 또는 모듈을 구분하기 위한 레이블 (예: "Home", "Profile")
    public init(label: String) {
        // Label별 Store와 전역 Store 둘 다에 로깅
        self.labelLogger = NetworkLogger(store: .labeledStore(name: label)) { config in
            config.label = label
        }

        self.globalLogger = NetworkLogger(store: .global) { config in
            config.label = label
        }
    }

    public func didCreateTask(_ task: URLSessionTask) {
        labelLogger.logTaskCreated(task)
        globalLogger.logTaskCreated(task)
    }

    public func didReceiveData(_ task: URLSessionDataTask, data: Data) {
        labelLogger.logDataTask(task, didReceive: data)
        globalLogger.logDataTask(task, didReceive: data)
    }

    public func didCompleteTask(_ task: URLSessionTask, error: Error?) {
        labelLogger.logTask(task, didCompleteWithError: error)
        globalLogger.logTask(task, didCompleteWithError: error)
    }
}
#endif
