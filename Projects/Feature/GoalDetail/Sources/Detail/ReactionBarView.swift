//
//  ReactionBarView.swift
//  FeatureGoalDetail
//
//  Created by 정지훈 on 2/6/26.
//

import SwiftUI

import SharedDesignSystem

struct ReactionBarView: View {
    let selectedIndex: Int?
    let onTap: (Int) -> Void
    
    @State private var flyingReactions: [FloatingReaction] = []
    private let emojis: [Image] = [
        Image.Icon.Illustration.happy,
        Image.Icon.Illustration.trouble,
        Image.Icon.Illustration.love,
        Image.Icon.Illustration.doubt,
        Image.Icon.Illustration.fuck
    ]
    
    init(
        selectedIndex: Int?,
        onTap: @escaping (Int) -> Void,
    ) {
        self.selectedIndex = selectedIndex
        self.onTap = onTap
    }
    
    var body: some View {
        GeometryReader { proxy in
            HStack(spacing: 0) {
                ForEach(emojis.indices, id: \.self) { index in
                    Button {
                        onTap(index)
                        emitFlyingReactions(for: index, width: proxy.size.width)
                    } label: {
                        emojis[index]
                            .padding(.horizontal, 8)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(selectedIndex == index ? Color.Gray.gray300 : Color.clear)
                    
                    if index != emojis.count - 1 {
                        Rectangle()
                            .frame(width: 1)
                    }
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
        .frame(maxWidth: .infinity, maxHeight: 68)
        .background(Color.Gray.gray100)
        .clipShape(.capsule)
        .overlay(
            Capsule()
                .stroke(Color.black, lineWidth: 1)
        )
        .overlay(alignment: .bottomLeading) {
            flyingReactionLayer
        }
    }
}

private extension ReactionBarView {
    struct FloatingReaction: Identifiable {
        let id = UUID()
        let emojiIndex: Int
        let startX: CGFloat
        let startY: CGFloat
        let startDate: Date
        let duration: TimeInterval
        let delay: TimeInterval
        let height: CGFloat
        let amplitude: CGFloat
        let frequency: CGFloat
        let drift: CGFloat
        let phase: CGFloat
        let scale: CGFloat
        let wobble: CGFloat
        
        func progress(at now: Date) -> CGFloat {
            CGFloat((now.timeIntervalSince(startDate) - delay) / duration)
        }
        
        func xOffset(at progress: CGFloat) -> CGFloat {
            let angle = Double((progress * frequency * 2 * .pi) + phase)
            let wobbleAngle = Double((progress * (frequency + 0.8) * 2 * .pi) + phase * 0.6)
            return startX
                + (CGFloat(sin(angle)) * amplitude)
                + (CGFloat(sin(wobbleAngle)) * wobble)
                + (drift * progress)
        }
        
        func yOffset(at progress: CGFloat) -> CGFloat {
            startY - (height * progress)
        }
        
        func opacity(at progress: CGFloat) -> Double {
            if progress < 0.25 { return Double(progress / 0.25) }
            if progress < 0.52 { return 1 }
            return Double(max(0, 1 - ((progress - 0.52) / 0.48)))
        }
    }
    
    var flyingReactionLayer: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 60.0)) { context in
            ZStack(alignment: .bottomLeading) {
                ForEach(flyingReactions) { reaction in
                    flyingReactionView(reaction, now: context.date)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
        }
        .allowsHitTesting(false)
    }
    
    @ViewBuilder
    func flyingReactionView(_ reaction: FloatingReaction, now: Date) -> some View {
        let progress = reaction.progress(at: now)
        if progress > 0, progress <= 1, reaction.emojiIndex < emojis.count {
            emojis[reaction.emojiIndex]
                .offset(x: reaction.xOffset(at: progress), y: reaction.yOffset(at: progress))
                .opacity(reaction.opacity(at: progress))
                .scaleEffect(reaction.scale)
        }
    }
    
    func emitFlyingReactions(for index: Int, width: CGFloat) {
        let minX: CGFloat = 8
        let maxXInset: CGFloat = 32
        let startY: CGFloat = -12
        let maxX = width - maxXInset
        let emojiCount = 20
        
        let newReactions = (0..<emojiCount).map { order in
            FloatingReaction(
                emojiIndex: index,
                startX: .random(in: minX...maxX),
                startY: startY,
                startDate: Date(),
                duration: .random(in: 0.85...1.35),
                delay: (Double(order) * 0.04) + .random(in: 0...0.02),
                height: .random(in: 340...540),
                amplitude: .random(in: 10...22),
                frequency: .random(in: 0.6...1.1),
                drift: .random(in: -28...28),
                phase: .random(in: 0...(CGFloat.pi * 2)),
                scale: .random(in: 0.84...1.22),
                wobble: .random(in: 1...4)
            )
        }
        
        flyingReactions.append(contentsOf: newReactions)
        
        let removeAt = (newReactions.map { $0.duration + $0.delay }.max() ?? 1.45) + 0.2
        
        Task { @MainActor in
            try await Task.sleep(for: .seconds(removeAt))
            let ids = Set(newReactions.map(\.id))
            flyingReactions.removeAll { ids.contains($0.id) }
        }
    }
}
