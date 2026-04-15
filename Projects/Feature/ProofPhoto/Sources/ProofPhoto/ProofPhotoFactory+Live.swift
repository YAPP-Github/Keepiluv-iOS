//
//  ProofPhotoFactory+Live.swift
//  FeatureProofPhoto
//
//  Created by 정지훈 on 1/25/26.
//

import SwiftUI

import ComposableArchitecture
import FeatureProofPhotoInterface

extension ProofPhotoFactory: DependencyKey {
    public static let liveValue = Self { store in
        AnyView(ProofPhotoView(store: store))
    }
}
