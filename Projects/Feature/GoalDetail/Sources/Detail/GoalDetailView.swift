//
//  GoalDetailView.swift
//  FeatureGoalDetail
//
//  Created by 정지훈 on 1/21/26.
//

import SwiftUI

import ComposableArchitecture
import FeatureGoalDetailInterface
import SharedDesignSystem

public struct GoalDetailView: View {
    
    @Bindable public var store: StoreOf<GoalDetailReducer>
    
    public init(store: StoreOf<GoalDetailReducer>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
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
            
            if store.isCompleted {
                createdAtText
                    .padding(.top, 14)
                    .padding(.trailing, 36)
                
                if store.isShowReactionBar {
                    reactionBar
                        .padding(.top, 73)
                        .padding(.horizontal, 21)
                }
            } else {
                pokeImage
                bottomButton
            }
        }
        .fullScreenCover(
            isPresented: $store.isPresentedProofPhoto) {
            IfLetStore(store.scope(state: \.proofPhoto, action: \.proofPhoto)) { store in
                ProofPhotoView(store: store)
            }
        }
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
    
    var completedImageCard: some View {
        store.item.image
            .resizable()
            .insideBorder(
                Color.Gray.gray500,
                shape: RoundedRectangle(cornerRadius: 20),
                lineWidth: 1.6
            )
            .frame(width: 336, height: 336)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(alignment: .bottom) {
                CommentCircle(commentText: store.item.commentText)
                    .padding(.bottom, 26)
            }
            .rotationEffect(.degrees(degree(isBackground: false)))
    }
    
    
    
    var createdAtText: some View {
        Text(store.item.createdAt)
            .typography(.b4_12b)
            .foregroundStyle(Color.Gray.gray300)
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    @ViewBuilder
    var reactionBar: some View {
        let emojis = [
            Image.Icon.Illustration.emoji1,
            Image.Icon.Illustration.emoji2,
            Image.Icon.Illustration.emoji3,
            Image.Icon.Illustration.emoji4,
            Image.Icon.Illustration.emoji5
        ]
        
        HStack(spacing: 0) {
            ForEach(emojis.indices, id: \.self) { index in
                emojis[index]
                    .padding(.horizontal, 8)
                
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
        Button {
            store.send(.bottomButtonTapped)
        } label: {
            Text(store.nonCompleteButtonText)
                .typography(.t2_16b)
                .foregroundStyle(Color.Gray.gray500)
                .frame(width: 150, height: 68)
                .background(.white)
                .clipShape(.capsule)
        }
        .buttonStyle(.plain)
        .insideBorder(Color.Gray.gray500, shape: .capsule, lineWidth: 1.6)
        .background(
            Capsule()
                .fill(Color.Gray.gray500)
                .frame(width: 150, height: 70)
                .padding(.top, 4)
        )
        .padding(.top, -28)
    }
}

// MARK: - Constants
private extension GoalDetailView {
    func degree(isBackground: Bool) -> Double {
        switch store.currentUser {
        case .me:
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
                item: .init(
                    image: SharedDesignSystemAsset.ImageAssets.boy.swiftUIImage,
                    commentText: "차타고슝슝",
                    createdAt: "6시간전",
                    selectedEmojiIndex: nil,
                    name: "민정"
                ),
                currentUser: .you,
                status: .pending
            ),
            reducer: {
                GoalDetailReducer()
            })
    )
}
