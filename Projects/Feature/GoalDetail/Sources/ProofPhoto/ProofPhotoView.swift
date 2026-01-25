//
//  ProofPhotoView.swift
//  FeatureGoalDetail
//
//  Created by 정지훈 on 1/22/26.
//

import SwiftUI

import ComposableArchitecture
import FeatureGoalDetailInterface
import SharedDesignSystem

public struct ProofPhotoView: View {

    @Bindable public var store: StoreOf<ProofPhotoReducer>

    public init(store: StoreOf<ProofPhotoReducer>) {
        self.store = store
    }

    public var body: some View {
        VStack(spacing: 0) {
            topBar
            titleText
                .padding(.top, 25)
            photoPreview
                .padding(.top, 38)
            bottomControls
                .padding(.horizontal, 41)
                .padding(.top, 52)
        }
        .ignoresSafeArea(.keyboard)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(.black)
        .onAppear {
            store.send(.onAppear)
        }
    }
}

// MARK: - SubViews
private extension ProofPhotoView {
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
    }

    @ViewBuilder
    var photoPreview: some View {
        if let session = store.captureSession {
            CameraPreview(session: session)
                .aspectRatio(1, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 76))
                .overlay(alignment: .top) {
                    previewTopControls
                }
                .overlay(alignment: .bottom) {
                    CommentCircle(
                        commentText: $store.commentText,
                        isEditable: true
                    )
                    .padding(.bottom, 26)
                }
                .insideBorder(
                    .white.opacity(0.2),
                    shape: RoundedRectangle(cornerRadius: 76),
                    lineWidth: 2
                )
        } else {
            Rectangle()
                .aspectRatio(1, contentMode: .fit)
        }
    }

    var previewTopControls: some View {
        HStack {
            Button {
                store.send(.flashButtonTapped)
            } label: {
                Image.Icon.Symbol.flash
                    .renderingMode(.template)
                    .foregroundStyle(
                        // FIXME: - 플래시 버튼 selected 디자인 나오면 수정
                        store.isFlashOn ? .red : Color.Common.white.opacity(0.6)
                    )
                    .frame(width: 44, height: 44)
                    .background(Color.Common.white.opacity(0.1), in: .circle)
            }

            Spacer()

            Button {
                
            } label: {
                /// 줌인/아웃 나중에 한다해서 주석 처리
//                Text(store.scopeText)
//                    .typography(.t2_16b)
//                    .foregroundStyle(Color.Common.white.opacity(0.6))
//                    .frame(width: 44, height: 44)
//                    .background(Color.Common.white.opacity(0.1), in: .circle)
            }
        }
        .padding([.top, .horizontal], 31)
    }

    var bottomControls: some View {
        HStack(spacing: 0) {
            galleryButton

            Spacer()

            captureButton

            Spacer()

            TXCircleButton(config: .cameraChange()) {
                store.send(.switchButtonTapped)
            }
        }
    }
    
    var galleryButton: some View {
        Button {
            
        } label: {
            store.galleryThumbnail
                .resizable()
                .insideBorder(
                    Color.Gray.gray300,
                    shape: RoundedRectangle(cornerRadius: 8),
                    lineWidth: 2
                )
                .frame(width: 52, height: 52)
                .clipShape(RoundedRectangle(cornerRadius: 8))
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
    }
}

#Preview {
    ProofPhotoView(
        store: Store(
            initialState: ProofPhotoReducer.State(
                galleryThumbnail: SharedDesignSystemAsset.ImageAssets.girl.swiftUIImage
            ),
            reducer: {
                ProofPhotoReducer()
            }
        )
    )
}
