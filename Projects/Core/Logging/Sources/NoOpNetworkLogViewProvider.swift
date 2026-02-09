//
//  NoOpNetworkLogViewProvider.swift
//  CoreLogging
//
//  Created by Jiyong
//

import CoreLoggingInterface
import SwiftUI

/// Release 빌드용 네트워크 로그 화면 제공자입니다.
///
/// Release 빌드에서는 Pulse가 포함되지 않으므로 빈 화면을 반환합니다.
public struct NoOpNetworkLogViewProvider: NetworkLogViewProviding {
    public init() {}

    @MainActor
    public func makePulseLogView(label: String) -> AnyView {
        AnyView(EmptyView())
    }
}
