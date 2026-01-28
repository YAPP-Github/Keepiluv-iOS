//
//  ShareSheet.swift
//  FeatureOnboarding
//
//  Created by Jiyong on 01/28/26.
//

import SwiftUI
import UIKit

/// iOS 네이티브 Share Sheet를 SwiftUI에서 사용하기 위한 래퍼입니다.
struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    var applicationActivities: [UIActivity]?
    var excludedActivityTypes: [UIActivity.ActivityType]?

    func makeUIViewController(
        context: Context
    ) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities
        )
        controller.excludedActivityTypes = excludedActivityTypes
        return controller
    }

    func updateUIViewController(
        _ uiViewController: UIActivityViewController,
        context: Context
    ) {}
}
