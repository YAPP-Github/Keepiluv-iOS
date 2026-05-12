//
//  ProofPhotoAnalyticsEvent+Parameter.swift
//  FeatureProofPhoto
//
//  Created by 정지훈 on 5/12/26.
//

import Foundation

extension ProofPhotoAnalyticsEvent {
    struct Upload {
        let goalId: Int64
        let targetDate: String
        let durationMS: Double
        let fileSizeKB: Double
    }
}
