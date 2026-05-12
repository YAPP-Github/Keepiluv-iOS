//
//  ProofPhotoAnalyticsEvent.swift
//  FeatureProofPhoto
//
//  Created by Jihun on 5/9/26.
//

import CoreAnalyticsInterface
import Foundation

enum ProofPhotoAnalyticsEvent: AnalyticsEvent {
    case uploaded(Upload)
    case opened

    var name: String {
        switch self {
        case .uploaded:
            "photo_uploaded"
            
        case .opened:
            "proof_photo_opened"
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case let .uploaded(parameter):
            [
                "goal_id": "\(parameter.goalId)",
                "target_Date": parameter.targetDate,
                "duration_ms": parameter.durationMS,
                "file_size_kb": parameter.fileSizeKB
            ]
            
        case .opened: nil
        }
    }
}
