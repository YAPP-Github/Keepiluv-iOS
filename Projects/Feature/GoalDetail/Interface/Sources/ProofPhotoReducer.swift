//
//  ProofPhotoReducer.swift
//  FeatureGoalDetailInterface
//
//  Created by 정지훈 on 1/22/26.
//

import AVFoundation
import SwiftUI

import ComposableArchitecture

/// ProofPhoto 화면의 상태와 액션을 정의하는 리듀서입니다.
@Reducer
public struct ProofPhotoReducer {
    let reducer: Reduce<State, Action>

    /// ProofPhoto 화면 렌더링에 필요한 상태입니다.
    @ObservableState
    public struct State {
        public var titleText: String = "인증샷을 올려보세요~"
        public var commentText: String = ""
        public var galleryThumbnail: Image
        public var scopeText: String = "1x"
        public var captureSession: AVCaptureSession?

        /// 상태를 생성합니다.
        ///
        /// ## 사용 예시
        /// ```swift
        /// let state = ProofPhotoReducer.State(
        ///     galleryThumbnail: image
        /// )
        /// ```
        public init(
            galleryThumbnail: Image
        ) {
            self.galleryThumbnail = galleryThumbnail
        }
    }

    /// ProofPhoto 화면에서 발생하는 액션입니다.
    public enum Action {
        case onAppear
        
        case closeButtonTapped
        
        case completedSetupCaptureSession(session: AVCaptureSession)
    }

    /// 외부에서 주입된 Reduce로 리듀서를 구성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let reducer = ProofPhotoReducer(
    ///     reducer: Reduce { _, _ in .none }
    /// )
    /// ```
    public init(reducer: Reduce<State, Action>) {
        self.reducer = reducer
    }

    public var body: some ReducerOf<Self> {
        reducer
    }
}
