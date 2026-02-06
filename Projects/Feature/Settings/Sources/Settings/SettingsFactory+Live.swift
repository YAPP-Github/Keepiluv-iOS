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
    public static let liveValue = Self { store in
        AnyView(SettingsView(store: store))
    }
}
