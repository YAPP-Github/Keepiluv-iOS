//
//  LoggerInterface.swift
//  CoreLoggingInterface
//
//  Created by Jiyong
//

import Foundation

/// 로그 레벨을 정의하는 열거형입니다.
///
/// OSLog의 로그 레벨에 대응하며, 심각도에 따라 debug, info, error, fault로 구분됩니다.
public enum LogLevel {
    case debug
    case info
    case error
    case fault
}

extension LogLevel {
    public var category: String {
        switch self {
        case .debug: return "DEBUG"
        case .info: return "INFO"
        case .error: return "ERROR"
        case .fault: return "FAULT"
        }
    }
}

/// 앱 전반에서 사용할 로거의 인터페이스를 정의합니다.
///
/// 이 프로토콜을 구현하여 로깅 동작을 커스터마이징할 수 있습니다.
/// 기본 구현으로 `TXLogger`를 제공합니다.
public protocol LoggerInterface {
    /// 로그 메시지를 기록합니다.
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
    /// let logger: LoggerInterface = TXLogger(label: "MyFeature")
    /// logger.log(
    ///     level: .info,
    ///     message: "User logged in",
    ///     file: #file,
    ///     line: #line,
    ///     function: #function
    /// )
    /// ```
    func log(
        level: LogLevel,
        message: String,
        file: String,
        line: Int,
        function: String
    )
}

// 편의를 위한 확장 (매번 file, line을 입력하지 않도록)
extension LoggerInterface {
    /// 디버그 레벨 로그를 기록합니다.
    ///
    /// - Parameter message: 로그 메시지
    ///
    /// ## 사용 예시
    /// ```swift
    /// let logger = TXLogger(label: "Home")
    /// logger.debug("View appeared")
    /// ```
    public func debug(
        _ message: String,
        file: String = #file,
        line: Int = #line,
        function: String = #function
    ) {
        log(
            level: .debug,
            message: message,
            file: file,
            line: line,
            function: function
        )
    }

    /// 정보 레벨 로그를 기록합니다.
    ///
    /// - Parameter message: 로그 메시지
    ///
    /// ## 사용 예시
    /// ```swift
    /// let logger = TXLogger(label: "Auth")
    /// logger.info("User signed in successfully")
    /// ```
    public func info(
        _ message: String,
        file: String = #file,
        line: Int = #line,
        function: String = #function
    ) {
        log(
            level: .info,
            message: message,
            file: file,
            line: line,
            function: function
        )
    }

    /// 에러 레벨 로그를 기록합니다.
    ///
    /// - Parameter message: 로그 메시지
    ///
    /// ## 사용 예시
    /// ```swift
    /// let logger = TXLogger(label: "Network")
    /// logger.error("API request failed: \(error.localizedDescription)")
    /// ```
    public func error(
        _ message: String,
        file: String = #file,
        line: Int = #line,
        function: String = #function
    ) {
        log(
            level: .error,
            message: message,
            file: file,
            line: line,
            function: function
        )
    }

    /// 치명적 오류 레벨 로그를 기록합니다.
    ///
    /// - Parameter message: 로그 메시지
    ///
    /// ## 사용 예시
    /// ```swift
    /// let logger = TXLogger(label: "Database")
    /// logger.fault("Critical: Database connection lost")
    /// ```
    public func fault(
        _ message: String,
        file: String = #file,
        line: Int = #line,
        function: String = #function
    ) {
        log(
            level: .fault,
            message: message,
            file: file,
            line: line,
            function: function
        )
    }
}
