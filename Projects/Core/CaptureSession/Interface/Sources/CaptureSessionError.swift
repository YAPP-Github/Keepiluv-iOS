//
//  CaptureSessionError.swift
//  CoreCaptureSessionInterface
//
//  Created by 정지훈 on 1/22/26.
//

import Foundation

public enum CaptureSessionError: Error {
    case sessionDeallocated
    case sessionNotConfigured
    case photoDataUnavailable
    case deviceInputNotCreated
}
