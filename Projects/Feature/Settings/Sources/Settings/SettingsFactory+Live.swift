//
//  SettingsFactory+Live.swift
//  FeatureSettings
//
//  Created by Jiyong on 02/05/26.
//

import ComposableArchitecture
import FeatureSettingsInterface
import SwiftUI

extension SettingsFactory: DependencyKey {
    public static let liveValue = Self(
        makeView: { store in
            AnyView(SettingsView(store: store))
        },
        makeAccountView: { store in
            AnyView(AccountView(store: store))
        },
        makeInfoView: { store in
            AnyView(InfoView(store: store))
        },
        makeNotificationSettingsView: { store in
            AnyView(NotificationSettingsView(store: store))
        },
        makeWebView: { store, url, title in
            AnyView(SettingsWebView(url: url, title: title, store: store))
        }
    )
}
