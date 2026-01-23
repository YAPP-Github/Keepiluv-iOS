//
//  GoalDetailView.swift
//
//
//  Created by Jihun on 01/21/26.
//

import SwiftUI
import CoreCaptureSession
import CoreCaptureSessionInterface
import ComposableArchitecture

@main
struct GoalDetailApp: App {
    var captureSessionClient = CaptureSessionClient.liveValue
    
    var body: some Scene {
        WindowGroup {
            GoalDetailExampleView()
                .task {
                    _ = await captureSessionClient.fetchIsAuthorized()
                }
        }
    }
}
