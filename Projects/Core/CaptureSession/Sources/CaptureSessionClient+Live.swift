//
//  CaptureSessionClient+Live.swift
//  CoreCaptureSessionInterface
//
//  Created by 정지훈 on 1/22/26.
//

import ComposableArchitecture
import Foundation

import CoreCaptureSessionInterface

extension CaptureSessionClient: @retroactive DependencyKey {
    public static let liveValue: CaptureSessionClient = {
        let manager = CaptureSessionManager()
        return Self(
            fetchIsAuthorized: { await manager.requestAuthorization() },
            setUpCaptureSession: { position in
                await manager.setUpSession(position: position)
                
                return manager.session
            },
            stopRunning: { manager.stopRunning() },
            capturePhoto: { try await manager.capturePhoto() }
        )
    }()
}
