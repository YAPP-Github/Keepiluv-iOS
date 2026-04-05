//
//  TXButton.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 4/3/26.
//

import SwiftUI

public struct TXButton: View {
    let shape: TXButtonShape
    let onTap: () -> Void
    
    public init(
        shape: TXButtonShape,
        onTap: @escaping () -> Void
    ) {
        self.shape = shape
        self.onTap = onTap
    }
    
    @ViewBuilder
    public var body: some View {
        switch shape {
        case .rect:
            TXRectButton(
                shape: shape,
                onTap: onTap
            )
        case .square(let style, let size, let state):
            EmptyView()
        case .round(let style, let size, let state):
            EmptyView()
        case .circle(let style, let size, let state):
            EmptyView()
        }
    }
}

#Preview {
//    TXButton()
}
