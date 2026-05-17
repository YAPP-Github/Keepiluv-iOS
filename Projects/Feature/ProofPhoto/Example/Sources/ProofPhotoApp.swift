import AVFoundation
import ComposableArchitecture
import CoreCaptureSession
import CoreCaptureSessionInterface
import CoreCrashlyticsInterface
import DomainPhotoLogInterface
import FeatureProofPhoto
import FeatureProofPhotoInterface
import SharedPerfTestingSupport
import SwiftUI

@main
struct ProofPhotoApp: App {
    init() {
        UITestMode.configureApplication()
    }

    var body: some Scene {
        WindowGroup {
            ProofPhotoView(
                store: Store(
                    initialState: ProofPhotoReducer.State(
                        goalId: 1,
                        verificationDate: "2026-02-07"
                    ),
                    reducer: { ProofPhotoReducer() },
                    withDependencies: {
                        $0.captureSessionClient = UITestMode.isEnabled ? .perfMock : .liveValue
                        $0.photoLogClient = .perfMock
                        $0.crashlyticsClient = .previewValue
                    }
                )
            )
            .perfRoot("proof-photo")
            .perfReadyMarker("proof-photo")
        }
    }
}

private extension CaptureSessionClient {
    static let perfMock = Self(
        fetchIsAuthorized: { true },
        setUpCaptureSession: { _ in AVCaptureSession() },
        stopRunning: {},
        capturePhoto: { Data() },
        switchCamera: { _ in },
        switchFlash: { _ in }
    )
}

private extension PhotoLogClient {
    static let perfMock = Self(
        fetchUploadURL: { _ in .init(uploadUrl: "", fileName: "") },
        uploadImageData: { _, _ in },
        createPhotoLog: { request in
            .init(
                photologId: 1,
                goalId: request.goalId,
                imageUrl: "",
                comment: request.comment,
                verificationDate: request.verificationDate
            )
        },
        updateReaction: { _, request in
            .init(photologId: 1, reaction: request.reaction)
        },
        updatePhotoLog: { _, _ in },
        deletePhotoLog: { _ in }
    )
}
