//
//  NetworkLogViewProviding.swift
//  CoreLoggingInterface
//
//  Created by Jiyong
//

import SwiftUI

#if DEBUG
import Pulse
#endif

public protocol NetworkLogViewProviding {
    @MainActor
    func makePulseLogView(label: String) -> AnyView
}
