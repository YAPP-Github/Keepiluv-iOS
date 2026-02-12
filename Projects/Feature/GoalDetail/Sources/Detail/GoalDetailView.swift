//
//  GoalDetailView.swift
//  FeatureGoalDetail
//
//  Created by 정지훈 on 1/21/26.
//

import SwiftUI
import UIKit

import ComposableArchitecture
import FeatureGoalDetailInterface
import FeatureProofPhotoInterface
import SharedDesignSystem

import Kingfisher

/// 목표 상세 화면을 렌더링하는 View입니다.
///
/// ## 사용 예시
/// ```swift
/// GoalDetailView(
///     store: Store(
///         initialState: GoalDetailReducer.State()
///     ) {
///         GoalDetailReducer(
///             proofPhotoReducer: ProofPhotoReducer()
///         )
///     }
/// )
/// ```
public struct GoalDetailView: View {
    
    @Bindable public var store: StoreOf<GoalDetailReducer>
    @Dependency(\.proofPhotoFactory) private var proofPhotoFactory
    @State private var rectFrame: CGRect = .zero
    @State private var keyboardFrame: CGRect = .zero
    
    /// GoalDetailView를 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let view = GoalDetailView(
    ///     store: Store(
    ///         initialState: GoalDetailReducer.State(
    ///             currentUser: .mySelf,
    ///             id: 1,
    ///             verificationDate: "2026-02-07"
    ///         )
    ///     ) {
    ///         GoalDetailReducer(proofPhotoReducer: ProofPhotoReducer())
    ///     }
    /// )
    /// ```
    public init(store: StoreOf<GoalDetailReducer>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            TXNavigationBar(
                style: .subTitle(
                    title: store.goalName,
                    rightText: store.naviBarRightText
                ),
                onAction: { action in
                    store.send(.navigationBarTapped(action))
                }
            )
            .overlay(dimmedView)

            ScrollView {
                ZStack(alignment: .bottom) {
                    if !store.isCompleted {
                        VStack {
                            Spacer()
                            bottomButton
                                .frame(maxWidth: .infinity)
                        }
                    }

                    if !store.isCompleted {
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                pokeImage
                                    .offset(x: -20, y: -20)
                            }
                        }
                    }

                    VStack(spacing: 0) {
                        ZStack {
                            backgroundRect
                            
                            SwipeableCardView(
                                isEditing: store.isEditing,
                                canSwipeUp: store.canSwipeUp,
                                canSwipeDown: store.canSwipeDown,
                                onCardTap: { store.send(.cardTapped) },
                                onSwipeUp: { store.send(.cardSwipedUp) },
                                onSwipeDown: { store.send(.cardSwipedDown) }
                            ) {
                                currentCardView
                            }
                        }
                        .padding(.horizontal, 27)
                        .padding(.top, 103)

                        if store.isCompleted {
                            completedBottomContent
                        } else {
                            Color.clear
                                .frame(height: 74)
                                .padding(.top, 105)
                        }
                    }
                }
                .padding(.bottom, 40)
            }
            .scrollIndicators(.hidden)
        }
        .ignoresSafeArea(.keyboard)
        .background(dimmedView)
        .toolbar(.hidden, for: .navigationBar)
        .observeKeyboardFrame($keyboardFrame)
        .onAppear {
            store.send(.onAppear)
        }
        .onDisappear {
            store.send(.onDisappear)
        }
        .fullScreenCover(
            isPresented: $store.isPresentedProofPhoto,
            onDismiss: { store.send(.proofPhotoDismissed) },
            content: {
                IfLetStore(store.scope(state: \.proofPhoto, action: \.proofPhoto)) { store in
                    proofPhotoFactory.makeView(store)
                }
            }
        )
        .cameraPermissionAlert(
            isPresented: $store.isCameraPermissionAlertPresented,
            onDismiss: { store.send(.cameraPermissionAlertDismissed) }
        )
        .overlay {
            if store.isSavingPhotoLog {
                ProgressView()
            }
        }
    }
}

// MARK: - SubViews
private extension GoalDetailView {
    var currentCardView: some View {
        Group {
            if store.isCompleted {
                completedImageCard
            } else {
                nonCompletedCard
                    .overlay(nonCompletedText)
            }
        }
        .animation(.spring(response: 0.36, dampingFraction: 0.86), value: store.currentUser)
    }
    
    var backgroundRect: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.Gray.gray200)
            .insideBorder(
                Color.Gray.gray500,
                shape: RoundedRectangle(cornerRadius: 20),
                lineWidth: 1.6
            )
            .frame(width: 336, height: 336)
            .overlay(dimmedView)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .rotationEffect(.degrees(degree(isBackground: true)))
    }
    
    @ViewBuilder
    var completedImageCard: some View {
        if let editImageData = store.pendingEditedImageData,
           let editedImage = UIImage(data: editImageData) {
            Image(uiImage: editedImage)
                .resizable()
                .insideBorder(
                    Color.Gray.gray500,
                    shape: RoundedRectangle(cornerRadius: 20),
                    lineWidth: 1.6
                )
                .frame(width: 336, height: 336)
                .readSize { rectFrame = $0 }
                .overlay(dimmedView)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(alignment: .bottom) {
                    commentCircle
                        .padding(.bottom, 26)
                }
                .rotationEffect(.degrees(degree(isBackground: false)))
        } else if let imageUrl = store.currentCard?.imageUrl,
                  let url = URL(string: imageUrl) {
            KFImage(url)
                .resizable()
                .insideBorder(
                    Color.Gray.gray500,
                    shape: RoundedRectangle(cornerRadius: 20),
                    lineWidth: 1.6
                )
                .frame(width: 336, height: 336)
                .readSize { rectFrame = $0 }
                .overlay(dimmedView)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(alignment: .bottom) {
                    commentCircle
                        .padding(.bottom, 26)
                }
                .rotationEffect(.degrees(degree(isBackground: false)))
        } else {
            EmptyView()
        }
    }
    
    @ViewBuilder
    var completedBottomContent: some View {
        if store.isEditing {
            bottomButton
                .padding(.top, 101)
                .padding(.horizontal, 30)
        } else {
            createdAtText
                .padding(.top, 14)
                .padding(.trailing, 36)
        }
        
        if store.isShowReactionBar {
            reactionBar
                .padding(.top, 73)
                .padding(.horizontal, 21)
        }
    }
    
    var createdAtText: some View {
        Text(store.createdAt)
            .typography(.b4_12b)
            .foregroundStyle(Color.Gray.gray300)
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    @ViewBuilder var reactionBar: some View {
        ReactionBarView(
            selectedEmoji: store.selectedReactionEmoji,
            onSelect: { emoji in
                store.send(.reactionEmojiTapped(emoji))
            }
        )
    }
    
    var nonCompletedCard: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(.white)
            .insideBorder(
                Color.Gray.gray500,
                shape: RoundedRectangle(cornerRadius: 20),
                lineWidth: 1.6
            )
            .frame(maxWidth: .infinity)
            .aspectRatio(1, contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .rotationEffect(.degrees(degree(isBackground: false)))
    }
    
    var nonCompletedText: some View {
        Text(store.explainText)
            .typography(.h2_24r)
            .foregroundStyle(Color.Gray.gray500)
            .multilineTextAlignment(.center)
    }
    
    var pokeImage: some View {
        Image.Illustration.poke
            .resizable()
            .frame(width: 173, height: 173)
            .allowsHitTesting(false)
    }

    var bottomButton: some View {
        TXShadowButton(
            config: store.isEditing ? .long(text: store.bottomButtonText) : .medium(text: store.bottomButtonText),
            colorStyle: .white
        ) {
            store.send(.bottomButtonTapped)
        }
    }
    
    @ViewBuilder
    var commentCircle: some View {
        let keyboardInset = max(0, rectFrame.maxY - keyboardFrame.minY)
        TXCommentCircle(
            commentText: store.isEditing ? $store.commentText : .constant(store.comment),
            isEditable: store.isEditing,
            keyboardInset: keyboardInset,
            isFocused: $store.isCommentFocused,
            onFocused: { isFocused in
                store.send(.focusChanged(isFocused))
            }
        )
        .animation(.easeOut(duration: 0.25), value: keyboardInset)
    }
    
    var dimmedView: some View {
        Color.Dimmed.dimmed70
            .opacity(store.isEditing && store.isCommentFocused ? 1 : 0)
            .transition(.opacity)
            .animation(.easeInOut, value: store.isCommentFocused)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .onTapGesture {
                store.send(.dimmedBackgroundTapped)
            }
    }
}

// MARK: - Constants
private extension GoalDetailView {
    func degree(isBackground: Bool) -> Double {
        switch store.currentUser {
        case .mySelf:
            return isBackground ? -8 : 0
            
        case .you:
            return isBackground ? 0 : -8
        }
    }
}

#Preview {
    GoalDetailView(
        store: Store(
            initialState: GoalDetailReducer.State(
                currentUser: .mySelf,
                id: 1,
                verificationDate: "2026-02-07"
            ),
            reducer: { }
        )
    )
}
