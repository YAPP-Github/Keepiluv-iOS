//
//  TXLogger.swift
//  CoreLogging
//
//  Created by Jiyong
//

import CoreLoggingInterface
import Foundation
import OSLog

/// Twix 앱의 기본 로거 구현체입니다.
///
/// OSLog를 기반으로 하며, Release 빌드에서 사용됩니다.
/// Feature별로 레이블을 지정하여 로그를 구분할 수 있습니다.
///
/// ## 사용 예시
/// ```swift
/// let logger = TXLogger(label: "Home")
/// logger.debug("Home view appeared")
/// logger.info("Data loaded successfully")
/// logger.error("Failed to load data: \(error)")
/// ```
public struct TXLogger: LoggerInterface {
    private let label: String

    /// TXLogger를 생성합니다.
    ///
    /// - Parameter label: Feature 또는 모듈을 구분하기 위한 레이블 (기본값: "App")
    ///
    /// ## 사용 예시
    /// ```swift
    /// // Feature별 로거 생성
    /// let homeLogger = TXLogger(label: "Home")
    /// let authLogger = TXLogger(label: "Auth")
    ///
    /// // 기본 레이블 사용
    /// let appLogger = TXLogger()
    /// ```
    public init(label: String = "App") {
        self.label = label
    }

    /// 로그 메시지를 OSLog에 기록합니다.
    ///
    /// - Parameters:
    ///   - level: 로그 레벨
    ///   - message: 로그 메시지
    ///   - file: 로그가 발생한 파일명
    ///   - line: 로그가 발생한 라인 번호
    ///   - function: 로그가 발생한 함수명
    ///
    /// ## 사용 예시
    /// ```swift
    /// let logger = TXLogger(label: "Network")
    /// logger.log(
    ///     level: .error,
    ///     message: "Request failed",
    ///     file: #file,
    ///     line: #line,
    ///     function: #function
    /// )
    /// ```
    public func log(level: LogLevel, message: String, file: String, line: Int, function: String) {
        let logMessage = "\(message)"

        // OSLog에 기록
        let subsystem = Bundle.main.bundleIdentifier ?? ""
        let logger = Logger(subsystem: subsystem, category: level.category)

        switch level {
        case .debug: logger.debug("\(logMessage)")
        case .info:  logger.info("\(logMessage)")
        case .error: logger.error("\(logMessage)")
        case .fault: logger.fault("\(logMessage)")
        }
    }
}
