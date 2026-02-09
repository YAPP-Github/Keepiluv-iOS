//
//  PulseNetworkLogViewProvider.swift
//  CoreLoggingDebug
//
//  Created by Jiyong
//

import CoreLoggingInterface
import Pulse
import PulseUI
import SwiftUI

public struct PulseNetworkLogViewProvider: NetworkLogViewProviding {
    public init() {}

    @MainActor
    public func makePulseLogView(label: String) -> AnyView {
        AnyView(
            NavigationStack {
                // Label별 Store 사용 - 해당 label의 로그만 자동 표시
                // .all mode: 네트워크 로그 + 일반 로그 모두 표시
                ConsoleView(store: .labeledStore(name: label), mode: .all)
                    .navigationTitle("\(label) Logs")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink("All") {
                                ConsoleView(store: .global, mode: .all)
                                    .navigationTitle("All Logs")
                            }
                        }
                    }
            }
        )
    }
}

extension LoggerStore {
    /// 전역 Store - 모든 로그 보기용 (All 버튼)
    static let global: LoggerStore = {
        createStore(name: "Global")
    }()

    /// Label별 개별 Store - 자동 필터링 효과
    static func labeledStore(name: String) -> LoggerStore {
        if let cached = labeledStores[name] {
            return cached
        }

        labeledStoresLock.lock()
        defer { labeledStoresLock.unlock() }

        if let cached = labeledStores[name] {
            return cached
        }

        let store = createStore(name: name)
        labeledStores[name] = store
        return store
    }

    private static func createStore(name: String) -> LoggerStore {
        let tempDir = FileManager.default.temporaryDirectory
        let folderURL = tempDir.appendingPathComponent("PulseLogs")
        let storeURL = folderURL.appendingPathComponent("\(name).pulse")

        do {
            try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true)
            let isExist = FileManager.default.fileExists(atPath: storeURL.path)
            let store = try LoggerStore(storeURL: storeURL, options: [isExist ? .sweep : .create])
            return store
        } catch {
            return .shared
        }
    }

    private static var labeledStores: [String: LoggerStore] = [:]
    private static let labeledStoresLock = NSLock()
}
