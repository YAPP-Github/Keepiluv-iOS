//
//  LoggerInterface.swift
//  CoreLoggingInterface
//
//  Created by Jiyong
//

import Foundation

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

public protocol LoggerInterface {
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
