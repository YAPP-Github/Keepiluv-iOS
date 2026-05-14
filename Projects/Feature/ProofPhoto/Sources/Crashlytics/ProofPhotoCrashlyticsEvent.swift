//
//  ProofPhotoCrashlyticsEvent.swift
//  FeatureProofPhoto
//

import CoreCrashlyticsInterface
import Foundation

enum ProofPhotoUploadStep: String, Sendable {
    case fetchURL
    case uploadS3
    case createLog
}

enum ProofPhotoCrashlyticsLogEvent: CrashlyticsLogEvent {
    case uploadStep(ProofPhotoUploadStep, goalId: Int64, imageBytes: Int?)

    var message: String {
        switch self {
        case let .uploadStep(step, goalId, imageBytes):
            if let imageBytes {
                "upload_step: \(step.rawValue), goalId=\(goalId), size=\(imageBytes)"
            } else {
                "upload_step: \(step.rawValue), goalId=\(goalId)"
            }
        }
    }
}

enum ProofPhotoCrashlyticsRecordEvent: CrashlyticsRecordEvent {
    case captureFailed(errorType: String)
    case uploadFailed(step: ProofPhotoUploadStep, goalId: Int64, originalImageBytes: Int)

    var customKeys: [String: String] {
        switch self {
        case let .captureFailed(errorType):
            [
                CrashlyticsKey.screen: "proof_photo_camera",
                CrashlyticsKey.captureErrorType: errorType
            ]

        case let .uploadFailed(step, goalId, originalImageBytes):
            [
                CrashlyticsKey.screen: "proof_photo_upload",
                CrashlyticsKey.uploadStep: step.rawValue,
                CrashlyticsKey.goalId: "\(goalId)",
                CrashlyticsKey.originalImageBytes: "\(originalImageBytes)"
            ]
        }
    }
}
