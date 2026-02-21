//
//  NotificationFactory+Live.swift
//  FeatureNotification
//
//  Created by Jiyong on 02/21/26.
//

import ComposableArchitecture
import FeatureNotificationInterface
import SwiftUI

extension NotificationFactory: DependencyKey {
    public static let liveValue = Self { store in
        AnyView(NotificationView(store: store))
    }
}
