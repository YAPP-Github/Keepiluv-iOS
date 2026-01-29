//
//  GoalDetailView.swift
//  FeatureGoalDetail
//
//  Created by 정지훈 on 1/21/26.
//

import SwiftUI

import ComposableArchitecture
import FeatureGoalDetailInterface
import FeatureProofPhotoInterface
import SharedDesignSystem

public struct GoalDetailView: View {
    
    @Bindable public var store: StoreOf<GoalDetailReducer>
    @Dependency(\.proofPhotoFactory)
    private var proofPhotoFactory
    
    public init(store: StoreOf<GoalDetailReducer>) {
        self.store = store
    }
    
    public var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                TXNavigationBar(
                    style: .subTitle(
                        title: store.item?.title ?? "",
                        rightText: store.naviBarRightText
                    )) { action in
                        store.send(.navigationBarTapped(action))
                    }
                
                ZStack {
                    backgroundRect
                    
                    if store.isCompleted {
                        completedImageCard
                    } else {
                        nonCompletedCard
                            .overlay(nonCompletedText)
                    }
                }
                .padding(.horizontal, 27)
                .padding(.top, 103)
                
                if store.isCompleted {
                    completedBottomContent
                } else {
                    pokeImage
                    bottomButton
                }
                
                Spacer()
            }
        }
        .ignoresSafeArea(.keyboard)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            store.send(.onAppear)
        }
        .fullScreenCover(
            isPresented: $store.isPresentedProofPhoto,
            onDismiss: { store.send(.proofPhotoDismissed)
            },
            content: {
                IfLetStore(store.scope(state: \.proofPhoto, action: \.proofPhoto)) { store in
                    proofPhotoFactory.makeView(store)
                }
            }
        )
    }
}

// MARK: - SubViews
private extension GoalDetailView {
    
    var backgroundRect: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.Gray.gray200)
            .insideBorder(
                Color.Gray.gray500,
                shape: RoundedRectangle(cornerRadius: 20),
                lineWidth: 1.6
            )
            .frame(width: 336, height: 336)
            .rotationEffect(.degrees(degree(isBackground: true)))
    }
    
    @ViewBuilder
    var completedImageCard: some View {
        if let image = store.currentCard?.image {
            image
                .resizable()
                .insideBorder(
                    Color.Gray.gray500,
                    shape: RoundedRectangle(cornerRadius: 20),
                    lineWidth: 1.6
                )
                .frame(width: 336, height: 336)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(alignment: .bottom) {
                    commentCircle
                        .padding(.bottom, 26)
                }
                .rotationEffect(.degrees(degree(isBackground: false)))
                .onTapGesture {
                    guard !store.isEditing else { return }
                    store.send(.cardTapped)
                }
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
        let emojis = [
            Image.Icon.Illustration.emoji1,
            Image.Icon.Illustration.emoji2,
            Image.Icon.Illustration.emoji3,
            Image.Icon.Illustration.emoji4,
            Image.Icon.Illustration.emoji5
        ]
        
        HStack(spacing: 0) {
            ForEach(emojis.indices, id: \.self) { index in
                let isSelected = store.selectedReactionIndex == index
                Button {
                    store.send(.reactionEmojiTapped(index))
                } label: {
                    emojis[index]
                        .padding(.horizontal, 8)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(isSelected ? Color.Gray.gray300 : Color.clear)
                if index != emojis.count - 1 {
                    Rectangle()
                        .frame(width: 1)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 68)
        .background(Color.Gray.gray100)
        .clipShape(.capsule)
        .overlay(
            Capsule()
                .stroke(Color.black, lineWidth: 1)
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
            .frame(width: 336, height: 336)
            .rotationEffect(.degrees(degree(isBackground: false)))
            .onTapGesture {
                if !store.isEditing {
                    store.send(.cardTapped)
                }
            }
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
            .frame(width: 136, height: 136)
            .scaleEffect(x: -1)
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    var bottomButton: some View {
        TXShadowButton(
            config: store.isEditing ? .long(text: store.bottomButtonText) : .medium(text: store.bottomButtonText),
            colorStyle: .white
        ) {
            store.send(.bottomButtonTapped)
        }
        .padding(.top, -28)
    }
    
    @ViewBuilder
    var commentCircle: some View {
        TXCommentCircle(
            commentText: store.isEditing ? $store.commentText : .constant(store.comment),
            isEditable: store.isEditing,
            usesKeyboardInset: false,
            isFocused: $store.isCommentFocused,
            onFocused: { isFocused in
                store.send(.focusChanged(isFocused))
            }
        )
    }
    
    var dimmedView: some View {
        Color.Dimmed.dimmed70
            .opacity(store.isEditing && store.isCommentFocused ? 1 : 0)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
            initialState: GoalDetailReducer.State(),
            reducer: { }
        )
    )
}
