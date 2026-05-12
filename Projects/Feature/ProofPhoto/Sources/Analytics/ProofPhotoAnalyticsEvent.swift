//
//  ProofPhotoAnalyticsEvent.swift
//  FeatureProofPhoto
//
//  Created by Jihun on 5/9/26.
//

import CoreAnalyticsInterface
import Foundation

enum ProofPhotoAnalyticsEvent: AnalyticsEvent {
    case uploaded(goalId: Int64, targetDate: String)

    var name: String {
        switch self {
        case .uploaded:
            "photo_uploaded"
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case let .uploaded(goalId, targetDate):
            [
                "goal_id": "\(goalId)",
                "target_Date": targetDate
            ]
        }
    }
}
