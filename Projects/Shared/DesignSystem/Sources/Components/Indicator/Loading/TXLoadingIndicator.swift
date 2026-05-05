//
//  TXLoadingIndicator.swift
//  SharedDesignSystem
//
//  Created by 정지용 on 5/5/26.
//

import SwiftUI

struct TXLoadingIndicator: View {
    @State private var rotation: Double = 0

    var body: some View {
        Circle()
            .trim(from: 0.175, to: 0.825)
            .stroke(
                Color.primary,
                style: StrokeStyle(
                    lineWidth: 1,
                    lineCap: .square
                )
            )
            .frame(width: 16, height: 16)
            .rotationEffect(.degrees(rotation))
            .onAppear {
                withAnimation(.linear(duration: 0.8).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
            }
    }
}

#Preview {
    TXLoadingIndicator()
}
