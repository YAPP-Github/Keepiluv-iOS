//
//  CaptureSessionClient.swift
//  CoreCaptureSessionInterface
//
//  Created by 정지훈 on 1/22/26.
//

import AVFoundation
import Dependencies

/// TCA Dependency로 주입 가능한 카메라 캡처 세션 클라이언트입니다.
///
/// ## 사용 예시
/// ```swift
/// @Dependency(\.captureSessionClient) var captureSessionClient
/// let fetchIsAuthorized = await captureSessionClient.fetchIsAuthorized()
/// await captureSessionClient.setUpCaptureSession(.back)
/// let imageData = try await captureSessionClient.capturePhoto()
/// ```
public struct CaptureSessionClient {
    
    public var fetchIsAuthorized: () async -> Bool
    public var setUpCaptureSession: (AVCaptureDevice.Position) async -> AVCaptureSession
    public var stopRunning: () -> Void
    public var capturePhoto: () async throws -> Data

    /// CaptureSessionClient를 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let client = CaptureSessionClient(
    ///     fetchIsAuthorized: { true },
    ///     requestAuthorization: { },
    ///     setUpCaptureSession: { _ in },
    ///     stopRunning: {},
    ///     capturePhoto: { Data() },
    /// )
    /// ```
    public init(
        fetchIsAuthorized: @escaping () async -> Bool,
        setUpCaptureSession: @escaping (AVCaptureDevice.Position) async -> AVCaptureSession,
        stopRunning: @escaping () -> Void,
        capturePhoto: @escaping () async throws -> Data
    ) {
        self.fetchIsAuthorized = fetchIsAuthorized
        self.setUpCaptureSession = setUpCaptureSession
        self.stopRunning = stopRunning
        self.capturePhoto = capturePhoto
    }
}

private enum CaptureSessionClientError: Error {
    case unimplemented
}

extension CaptureSessionClient: TestDependencyKey {
    public static let testValue = Self(
        fetchIsAuthorized: {
            assertionFailure("fetchIsAuthorized is unimplemented. Use withDependencies to override.")
            return false
        },
        setUpCaptureSession: { _ in
            assertionFailure("setUpCaptureSession is unimplemented. Use withDependencies to override.")
            
            return AVCaptureSession()
        },
        stopRunning: {
            assertionFailure("stopRunning is unimplemented. Use withDependencies to override.")
        },
        capturePhoto: {
            assertionFailure("capturePhoto is unimplemented. Use withDependencies to override.")
            throw CaptureSessionClientError.unimplemented
        }
    )
}

public extension DependencyValues {
    var captureSessionClient: CaptureSessionClient {
        get { self[CaptureSessionClient.self] }
        set { self[CaptureSessionClient.self] = newValue }
    }
}
