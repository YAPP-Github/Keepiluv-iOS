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
    let canSwipeLeft: Bool
    let canSwipeRight: Bool
    let onSwipeLeft: () -> Void
    let onSwipeRight: () -> Void
    let content: Content
    
    @State private var cardOffset: CGSize = .zero
    @State private var cardOpacity: Double = 1
    
    init(
        canSwipeLeft: Bool,
        canSwipeRight: Bool,
        onSwipeLeft: @escaping () -> Void,
        onSwipeRight: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.canSwipeLeft = canSwipeLeft
        self.canSwipeRight = canSwipeRight
        self.onSwipeLeft = onSwipeLeft
        self.onSwipeRight = onSwipeRight
        self.content = content()
    }
    
    var body: some View {
        content
            .offset(cardOffset)
            .opacity(cardOpacity)
            .rotationEffect(.degrees(swipeRotation))
            .contentShape(RoundedRectangle(cornerRadius: 20))
            .gesture(cardSwipeGesture)
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
                let translation = value.translation

                guard abs(translation.width) >= abs(translation.height) else {
                    cardOffset = .zero
                    return
                }

                cardOffset = CGSize(width: translation.width, height: 0)
            }
            .onEnded { value in
                guard let direction = swipeDirection(for: value.translation) else {
                    resetCardOffset()
                    return
                }
                
                switch direction {
                case .left:
                    if !canSwipeLeft {
                        resetCardOffset()
                        return
                    }
                    
                case .right:
                    if !canSwipeRight {
                        resetCardOffset()
                        return
                    }
                }
                completeSwipe(direction: direction)
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
            case .left:
                guard canSwipeLeft else { return }
                onSwipeLeft()
                
            case .right:
                guard canSwipeRight else { return }
                onSwipeRight()
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
