//
//  CaptureSessionManager.swift
//  CoreCaptureSession
//
//  Created by 정지훈 on 1/22/26.
//

import AVFoundation
import Foundation

import CoreCaptureSessionInterface

final class CaptureSessionManager: NSObject, @unchecked Sendable {
    
    let session = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "org.twix.capturesession")
    private let photoOutput = AVCapturePhotoOutput()
    private var continuation: CheckedContinuation<Data, Error>?
    
    func requestAuthorization() async -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            return true
            
        case .notDetermined:
            return await AVCaptureDevice.requestAccess(for: .video)
            
        case .denied, .restricted:
            return false
            
        @unknown default:
            return false
        }
    }

    func setUpSession(position: AVCaptureDevice.Position) async {
        guard await requestAuthorization() else { return }
        
        await performOnSessionQueue { [weak self] in
            guard let self else { return }
            
            self.session.beginConfiguration()
            self.session.sessionPreset = .photo
            self.session.inputs.forEach { self.session.removeInput($0) }

            addPhotoOutputIfNeeded()

            guard let device = AVCaptureDevice.default(
                .builtInWideAngleCamera,
                for: .video,
                position: position
            ) else {
                self.session.commitConfiguration()
                return
            }
            
            addPhotoInputIfNeeded(for: device)
            self.session.commitConfiguration()
            startRunningIfNeeded()
        }
    }

    func stopRunning() {
        sessionQueue.async { [session] in
            guard session.isRunning else { return }
            session.stopRunning()
        }
    }
    
    func capturePhoto() async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            sessionQueue.async { [weak self] in
                guard let self else {
                    continuation.resume(throwing: CaptureSessionError.sessionDeallocated)
                    return
                }

                guard self.session.outputs.contains(self.photoOutput) else {
                    continuation.resume(throwing: CaptureSessionError.sessionNotConfigured)
                    return
                }

                if !self.session.isRunning {
                    self.session.startRunning()
                }

                self.continuation = continuation
                self.photoOutput.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
            }
        }
    }
    
    func switchCamera(isFront: Bool) async {
        let position: AVCaptureDevice.Position = isFront ? .front : .back
        await setUpSession(position: position)
    }
}

// MARK: - AVCapturePhotoCaptureDelegate
extension CaptureSessionManager: AVCapturePhotoCaptureDelegate {
    func photoOutput(
        _ output: AVCapturePhotoOutput,
        didFinishProcessingPhoto photo: AVCapturePhoto,
        error: Error?
    ) {
        defer {
            continuation = nil
        }

        if let error {
            continuation?.resume(throwing: error)
            return
        }

        guard let data = photo.fileDataRepresentation() else {
            continuation?.resume(throwing: CaptureSessionError.photoDataUnavailable)
            return
        }

        continuation?.resume(returning: data)
    }
}

// MARK: - Private Methods
private extension CaptureSessionManager {
    func performOnSessionQueue(_ work: @escaping () -> Void) async {
        await withCheckedContinuation { continuation in
            sessionQueue.async {
                work()
                continuation.resume()
            }
        }
    }
    
    func addPhotoOutputIfNeeded() {
        if !session.outputs.contains(photoOutput),
           session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
        }
    }
    
    func addPhotoInputIfNeeded(for device: AVCaptureDevice) {
        guard let input = try? AVCaptureDeviceInput(device: device) else { return }
        
        if self.session.canAddInput(input) {
            self.session.addInput(input)
        }
    }
    
    func startRunningIfNeeded() {
        if !self.session.isRunning {
            self.session.startRunning()
        }
    }
}
