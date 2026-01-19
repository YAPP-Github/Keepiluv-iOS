//
//  Source.swift
//  Feature
//
//  Created by Jiyong on 1/15/26.
//

import FeatureAuth
import FeatureMainTab

// MARK: - Auth Re-exports

/// Feature Root에서 Auth의 타입들을 명시적으로 노출합니다.
/// App은 Feature만 import하면 하위 Feature들의 타입을 사용할 수 있습니다.
public typealias AuthReducer = FeatureAuth.AuthReducer
public typealias AuthView = FeatureAuth.AuthView

// MARK: - MainTab Re-exports

/// Feature Root에서 MainTab의 타입들을 명시적으로 노출합니다.
/// App은 Feature만 import하면 하위 Feature들의 타입을 사용할 수 있습니다.
public typealias MainTabView = FeatureMainTab.MainTabView
public typealias MainTabReducer = FeatureMainTab.MainTabReducer
