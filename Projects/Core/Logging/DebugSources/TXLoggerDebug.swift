//
//  TXLoggerDebug.swift
//  CoreLoggingDebug
//
//  Created by Jiyong
//

import CoreLogging
import CoreLoggingInterface
import Foundation
import Pulse

/// Twix 앱의 Debug 전용 로거 구현체입니다.
///
/// OSLog를 기반으로 하며, Pulse에도 로그를 미러링합니다.
/// Feature별로 레이블을 지정하여 로그를 구분할 수 있습니다.
///
/// ## 사용 예시
/// ```swift
/// let logger = TXLoggerDebug(label: "Home")
/// logger.debug("Home view appeared")
/// logger.info("Data loaded successfully")
/// logger.error("Failed to load data: \(error)")
/// ```
public struct TXLoggerDebug: LoggerInterface {
    private let label: String
    private let baseLogger: TXLogger

    /// TXLoggerDebug를 생성합니다.
    ///
    /// - Parameter label: Feature 또는 모듈을 구분하기 위한 레이블 (기본값: "App")
    ///
    /// ## 사용 예시
    /// ```swift
    /// // Feature별 로거 생성
    /// let homeLogger = TXLoggerDebug(label: "Home")
    /// let authLogger = TXLoggerDebug(label: "Auth")
    ///
    /// // 기본 레이블 사용
    /// let appLogger = TXLoggerDebug()
    /// ```
    public init(label: String = "App") {
        self.label = label
        self.baseLogger = TXLogger(label: label)
    }

    /// 로그 메시지를 OSLog와 Pulse에 기록합니다.
    ///
    /// - Parameters:
    ///   - level: 로그 레벨
    ///   - message: 로그 메시지
    ///   - file: 로그가 발생한 파일명
    ///   - line: 로그가 발생한 라인 번호
    ///   - function: 로그가 발생한 함수명
    public func log(level: LogLevel, message: String, file: String, line: Int, function: String) {
        // OSLog에 기록 (기존 TXLogger 활용)
        baseLogger.log(level: level, message: message, file: file, line: line, function: function)

        // Pulse에도 미러 로그 기록
        let fileName = (file as NSString).lastPathComponent
        mirrorToPulse(
            level: level,
            message: message,
            file: fileName,
            line: line,
            function: function
        )
    }

    // swiftlint:disable:next function_parameter_count
    private func mirrorToPulse(
        level: LogLevel,
        message: String,
        file: String,
        line: Int,
        function: String
    ) {
        // Label별 Store에 기록
        let labelStore = LoggerStore.labeledStore(name: label)
        storeMessage(
            to: labelStore,
            level: level,
            message: message,
            file: file,
            line: line,
            function: function
        )

        // Global Store에도 기록
        let globalStore = LoggerStore.global
        storeMessage(
            to: globalStore,
            level: level,
            message: message,
            file: file,
            line: line,
            function: function
        )
    }

    // swiftlint:disable:next function_parameter_count
    private func storeMessage(
        to store: LoggerStore,
        level: LogLevel,
        message: String,
        file: String,
        line: Int,
        function: String
    ) {
        let pulseLevel: Pulse.LoggerStore.Level
        switch level {
        case .debug: pulseLevel = .debug
        case .info: pulseLevel = .info
        case .error: pulseLevel = .error
        case .fault: pulseLevel = .critical
        }

        store.storeMessage(
            label: label,
            level: pulseLevel,
            message: message,
            metadata: [
                "file": .string(file),
                "line": .string("\(line)"),
                "function": .string(function)
            ]
        )
    }
}
