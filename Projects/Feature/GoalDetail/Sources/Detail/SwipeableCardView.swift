//
//  SwipeableCardView.swift
//  FeatureGoalDetail
//
//  Created by 정지훈 on 2/6/26.
//

import SwiftUI

struct SwipeableCardView<Content: View>: View {
    enum SwipeDirection {
        case left
        case right
        
        var exitOffset: CGSize {
            switch self {
            case .left:
                return CGSize(width: -420, height: 0)
                
            case .right:
                return CGSize(width: 420, height: 0)
            }
        }
    }
    
    let isEditing: Bool
    let onCardTap: () -> Void
    let content: Content
    
    @State private var cardOffset: CGSize = .zero
    @State private var cardOpacity: Double = 1
    
    init(
        isEditing: Bool,
        onCardTap: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.isEditing = isEditing
        self.onCardTap = onCardTap
        self.content = content()
    }
    
    var body: some View {
        content
            .offset(cardOffset)
            .opacity(cardOpacity)
            .rotationEffect(.degrees(swipeRotation))
            .contentShape(RoundedRectangle(cornerRadius: 20))
            .onTapGesture { handleCardTap() }
            .gesture(cardSwipeGesture)
            .onChange(of: isEditing) {
                if isEditing { resetCardOffset() }
            }
    }
}

// MARK: - Private Methods
private extension SwipeableCardView {
    var swipeRotation: Double {
        max(-8, min(8, Double(cardOffset.width / 28)))
    }
    
    var cardSwipeGesture: some Gesture {
        DragGesture(minimumDistance: 16)
            .onChanged { value in
                guard !isEditing else { return }
                let translation = value.translation

                guard abs(translation.width) >= abs(translation.height) else {
                    cardOffset = .zero
                    return
                }

                cardOffset = CGSize(width: translation.width, height: 0)
            }
            .onEnded { value in
                guard !isEditing else {
                    resetCardOffset()
                    return
                }
                
                guard let direction = swipeDirection(for: value.translation) else {
                    resetCardOffset()
                    return
                }
                
                completeSwipe(direction: direction)
            }
    }
    
    func handleCardTap() {
        guard !isEditing else { return }
        withAnimation(.spring(response: 0.36, dampingFraction: 0.86)) {
            onCardTap()
        }
    }
    
    func swipeDirection(for translation: CGSize) -> SwipeDirection? {
        let threshold: CGFloat = 60
        guard abs(translation.width) > abs(translation.height) else { return nil }
        guard abs(translation.width) > threshold else { return nil }
        return translation.width > 0 ? .right : .left
    }
    
    func completeSwipe(direction: SwipeDirection) {
        let exitOffset = direction.exitOffset
        
        withAnimation(.easeOut(duration: 0.15)) {
            cardOffset = exitOffset
            cardOpacity = 0
        }
        
        Task { @MainActor in
            try await Task.sleep(for: .seconds(0.15))
            switch direction {
            case .left, .right:
                onCardTap()
            }
            cardOffset = CGSize(width: -exitOffset.width * 0.2, height: -exitOffset.height * 0.2)
            withAnimation(.spring(response: 0.34, dampingFraction: 0.84)) {
                cardOffset = .zero
                cardOpacity = 1
            }
        }
    }
    
    func resetCardOffset() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
            cardOffset = .zero
            cardOpacity = 1
        }
    }
}
