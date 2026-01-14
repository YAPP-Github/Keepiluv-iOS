//
//  TXLogger.swift
//  CoreLogging
//
//  Created by Jiyong
//

import CoreLoggingInterface
import Foundation
import OSLog

#if DEBUG
import Pulse
#endif

public struct TXLogger: LoggerInterface {
    private let label: String

    /// TXLogger를 생성합니다.
    /// - Parameter label: Feature 또는 모듈을 구분하기 위한 레이블 (예: "Home", "Profile")
    public init(label: String = "App") {
        self.label = label
    }

    public func log(level: LogLevel, message: String, file: String, line: Int, function: String) {
        let fileName = (file as NSString).lastPathComponent
        let logMessage = "\(message)"
        _ = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"

        // OSLog에 기록
        let subsystem = Bundle.main.bundleIdentifier ?? ""
        let logger = Logger(subsystem: subsystem, category: level.category)

        switch level {
        case .debug: logger.debug("\(logMessage)")
        case .info:  logger.info("\(logMessage)")
        case .error: logger.error("\(logMessage)")
        case .fault: logger.fault("\(logMessage)")
        }

        // Pulse에도 mirror 로그 기록 (DEBUG 전용)
        #if DEBUG
        mirrorToPulse(
            level: level,
            message: logMessage,
            file: fileName,
            line: line,
            function: function
        )
        #endif
    }

    #if DEBUG
    private func mirrorToPulse(level: LogLevel, message: String, file: String, line: Int, function: String) {
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
    #endif
}
