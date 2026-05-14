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

// MARK: - CustomNSError

extension CaptureSessionError: CustomNSError {
    public static var errorDomain: String { "org.yapp.twix.capture" }

    public var errorCode: Int {
        switch self {
        case .sessionDeallocated:    return 1
        case .sessionNotConfigured:  return 2
        case .photoDataUnavailable:  return 3
        case .deviceInputNotCreated: return 4
        }
    }
}
