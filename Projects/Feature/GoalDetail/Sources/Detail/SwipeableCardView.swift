//
//  SwipeableCardView.swift
//  FeatureGoalDetail
//
//  Created by 정지훈 on 2/6/26.
//

import SwiftUI

struct SwipeableCardView<Content: View>: View {
    enum SwipeDirection {
        case up
        case down
        case left
        case right
        
        var exitOffset: CGSize {
            switch self {
            case .up:
                return CGSize(width: 0, height: -420)
                
            case .down:
                return CGSize(width: 0, height: 420)
                
            case .left:
                return CGSize(width: -420, height: 0)
                
            case .right:
                return CGSize(width: 420, height: 0)
            }
        }
    }
    
    let isEditing: Bool
    let canSwipeUp: Bool
    let canSwipeDown: Bool
    let onCardTap: () -> Void
    let onSwipeUp: () -> Void
    let onSwipeDown: () -> Void
    let content: Content
    
    @State private var cardOffset: CGSize = .zero
    @State private var cardOpacity: Double = 1
    
    init(
        isEditing: Bool,
        canSwipeUp: Bool,
        canSwipeDown: Bool,
        onCardTap: @escaping () -> Void,
        onSwipeUp: @escaping () -> Void,
        onSwipeDown: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.isEditing = isEditing
        self.canSwipeUp = canSwipeUp
        self.canSwipeDown = canSwipeDown
        self.onCardTap = onCardTap
        self.onSwipeUp = onSwipeUp
        self.onSwipeDown = onSwipeDown
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
                cardOffset = value.translation
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
                
                if direction == .up && !canSwipeUp {
                    resetCardOffset()
                    return
                }
                
                if direction == .down && !canSwipeDown {
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
        let isHorizontal = abs(translation.width) > abs(translation.height)
        
        if isHorizontal {
            guard abs(translation.width) > threshold else { return nil }
            return translation.width > 0 ? .right : .left
        } else {
            guard abs(translation.height) > threshold else { return nil }
            return translation.height > 0 ? .down : .up
        }
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
            case .up:
                onSwipeUp()
            case .down:
                onSwipeDown()
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
