//
//  ProofPhotoView.swift
//  FeatureProofPhoto
//
//  Created by 정지훈 on 1/22/26.
//

import PhotosUI
import SwiftUI

import ComposableArchitecture
import FeatureProofPhotoInterface
import SharedDesignSystem
import SharedUtil

/// 인증샷 화면을 렌더링하는 View입니다.
///
/// ## 사용 예시
/// ```swift
/// ProofPhotoView(
///     store: Store(
///         initialState: ProofPhotoReducer.State(
///             goalId: 1,
///             verificationDate: "2026-02-07"
///         )
///     ) {
///         ProofPhotoReducer()
///     }
/// )
/// ```
public struct ProofPhotoView: View {

    @Bindable public var store: StoreOf<ProofPhotoReducer>
    
    @State private var rectFrame: CGRect = .zero
    @State private var keyboardFrame: CGRect = .zero

    /// ProofPhotoView를 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let view = ProofPhotoView(
    ///     store: Store(
    ///         initialState: ProofPhotoReducer.State(
    ///             goalId: 1,
    ///             verificationDate: "2026-02-07"
    ///         )
    ///     ) { ProofPhotoReducer() }
    /// )
    /// ```
    public init(store: StoreOf<ProofPhotoReducer>) {
        self.store = store
    }

    public var body: some View {
        ZStack {
            mainContent

            if store.isCommentFocused {
                dimmedView
                    .ignoresSafeArea()
            }

            if shouldShowCommentOverlay {
                floatingCommentOverlay
            }
        }
        .ignoresSafeArea(.keyboard)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .observeKeyboardFrame($keyboardFrame)
        .background(Color.Gray.gray500)
        .onAppear {
            store.send(.onAppear)
        }
        .txToast(item: $store.toast, customPadding: 75)
    }
}

// MARK: - SubViews
private extension ProofPhotoView {
    var mainContent: some View {
        VStack(spacing: 0) {
            topBar
            titleText
                .padding(.top, 25)
            photoPreview
                .padding(.top, 40)
                .padding(.horizontal, 5)
            bottomControls
                .padding(.top, 52)
            
            Spacer()
        }
    }

    var shouldShowCommentOverlay: Bool {
        (store.captureSession != nil || store.hasImage) && rectFrame != .zero
    }

    var topBar: some View {
        HStack(spacing: 0) {
            Spacer()
            
            Button {
                store.send(.closeButtonTapped)
            } label: {
                Image.Icon.Symbol.closeM
                    .renderingMode(.template)
                    .foregroundStyle(Color.Gray.gray100)
                    .frame(width: 44, height: 44)
            }
        }
        .frame(height: 72)
    }
    
    var titleText: some View {
        Text(store.titleText)
            .typography(.h2_24r)
            .foregroundStyle(Color.Gray.gray100)
            .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    var photoPreview: some View {
        if store.hasImage,
           let imageData = store.imageData,
           let image = UIImage(data: imageData) {
            previewContainer {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            }
        } else if let session = store.captureSession {
            previewContainer {
                CameraPreview(session: session)
            }
        } else {
            Rectangle()
                .frame(maxWidth: .infinity)
                .aspectRatio(1, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 76))
        }
    }

    var previewTopControls: some View {
        HStack {
            Button {
                store.send(.flashButtonTapped)
            } label: {
                flashIcon
                    .renderingMode(.template)
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(Color.Common.white.opacity(0.1), in: .circle)
            }

            Spacer()

            Button { } label: {
                // 줌인/아웃 나중에 한다해서 주석 처리
//                Text(store.scopeText)
//                    .typography(.t2_16b)
//                    .foregroundStyle(Color.Common.white.opacity(0.6))
//                    .frame(width: 44, height: 44)
//                    .background(Color.Common.white.opacity(0.1), in: .circle)
            }
        }
        .padding([.top, .horizontal], 31)
    }

    var flashIcon: Image {
        store.isFlashOn ? Image.Icon.Symbol.flash : Image.Icon.Symbol.flashDefault
    }

    @ViewBuilder
    var bottomControls: some View {
        Group {
            if store.hasImage {
                uploadControls
            } else {
                captureControls
            }
        }
        .frame(height: 74)
    }
    
    var captureControls: some View {
        HStack(spacing: 52) {
            galleryButton
            captureButton
            TXCircleButton(config: .cameraChange()) {
                store.send(.switchButtonTapped)
            }
        }
    }
    
    var uploadControls: some View {
        HStack(spacing: Spacing.spacing6) {
            Button {
                store.send(.returnButtonTapped)
            } label: {
                Image.Icon.Symbol.icReturn
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(Color.Common.white)
                    .frame(width: 36, height: 36)
                    .frame(width: 50, height: 50)
            }
            
            TXShadowButton(
                config: .medium(text: "업로드"),
                colorStyle: .black
            ) {
                store.send(.uploadButtonTapped)
            }
            
            Color.clear
                .frame(width: 50)
        }
        .frame(maxWidth: .infinity)
    }
    
    var galleryButton: some View {
        PhotosPicker(
            selection: $store.selectedPhotoItem,
            matching: .images,
            photoLibrary: .shared()
        ) {
            Image.Icon.Symbol.gallery
                .renderingMode(.template)
                .foregroundStyle(Color.Common.white)
                .frame(width: 56, height: 56)
                .background(Color.Gray.gray400, in: .circle)
        }
    }
    
    var captureButton: some View {
        Button {
            store.send(.captureButtonTapped)
        } label: {
            Circle()
                .fill(.white)
                .frame(width: 66, height: 66)
                .background(
                    Circle()
                        .fill(Color.Gray.gray400)
                        .insideBorder(
                            Color.Gray.gray300,
                            shape: .circle,
                            lineWidth: 3
                        )
                        .shadow(color: .black.opacity(0.1), radius: 10)
                        .frame(width: 84, height: 84)
                )
        }
        .disabled(store.isCapturing)
    }
    
    var dimmedView: some View {
        Color.Dimmed.dimmed70
            .opacity(store.isCommentFocused ? 1 : 0)
            .transition(.opacity)
            .animation(.easeInOut, value: store.isCommentFocused)
            .onTapGesture {
                store.send(.dimmedBackgroundTapped)
            }
    }
}

// MARK: - Preiview Methods
private extension ProofPhotoView {
    
    func previewContainer(
        @ViewBuilder content: @escaping () -> some View
    ) -> some View {
        let shape = RoundedRectangle(cornerRadius: 76)

        return Color.clear
            .frame(maxWidth: .infinity)
            .aspectRatio(1, contentMode: .fit)
            .readSize { rectFrame = $0 }
            .overlay {
                content()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
            }
            .clipShape(shape)
            .overlay(alignment: .top) {
                if !store.hasImage {
                    previewTopControls
                }
            }
            .insideBorder(
                .white.opacity(0.2),
                shape: shape,
                lineWidth: 2
            )
    }

    var floatingCommentOverlay: some View {
        GeometryReader { rootGeo in
            let rootFrame = rootGeo.frame(in: .global)
            let posX = rectFrame.minX - rootFrame.minX
            let posY = rectFrame.minY - rootFrame.minY

            VStack(spacing: 8) {
                if store.isCommentFocused {
                    commentExpalinText
                }
                commentCircle
            }
            .padding(.bottom, 26)
            .frame(width: rectFrame.width, height: rectFrame.height, alignment: .bottom)
            .offset(x: posX, y: posY)
            .animation(.easeOut(duration: 0.25), value: keyboardInset)
        }
    }
    
    var commentExpalinText: some View {
        Text("5글자로 코멘트를 남길 수 있어요")
            .typography(.b2_14r)
            .foregroundStyle(Color.Gray.gray100)
    }
    
    var commentCircle: some View {
        TXCommentCircle(
            commentText: $store.commentText,
            isEditable: true,
            keyboardInset: keyboardInset,
            isFocused: $store.isCommentFocused,
            onFocused: { isFocused in
                store.send(.focusChanged(isFocused))
            }
        )
    }
}

// MARK: - Private Methods
private extension ProofPhotoView {
    var keyboardInset: CGFloat { max(0, rectFrame.maxY - keyboardFrame.minY) }
}

#Preview {
    ProofPhotoView(
        store: Store(
            initialState: ProofPhotoReducer.State(
                goalId: 2,
                verificationDate: TXCalendarUtil.apiDateString(
                    for: TXCalendarDate(
                        year: CalendarNow().year,
                        month: CalendarNow().month,
                        day: CalendarNow().day
                    )
                )
            ),
            reducer: {
                ProofPhotoReducer()
            }
        )
    )
}
