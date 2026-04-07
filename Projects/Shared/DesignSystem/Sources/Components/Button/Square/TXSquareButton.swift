//
//  TXSquareButton.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/15/26.
//

import SwiftUI

struct TXSquareButton: View {
    let shape: TXButtonShape
    let onTap: () -> Void
    
    public var body: some View {
        if case let .square(style, _, _, edges) = shape {
            Button(action: onTap) {
                switch style {
                case let .lineIcon(icon):
                    icon
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: Constants.iconSize.width, height: Constants.iconSize.height)
                        .foregroundStyle(Constants.foregroundColor)
                    
                case let .lineText(text):
                    Text(text)
                        .typography(Constants.typhography)
                        .foregroundStyle(Constants.foregroundColor)
                }
            }
            .frame(width: Constants.frameSize.width, height: Constants.frameSize.height)
            .insideRectEdgeBorder(
                width: Constants.borderWidth,
                edges: edges,
                color: Constants.borderColor
            )
            .buttonStyle(.plain)
        } else {
            EmptyView()
        }
    }
}

// MARK: - Constants
private extension TXSquareButton {
    enum Constants {
        static let iconSize: CGSize = .init(width: 24, height: 24)
        static let frameSize: CGSize = .init(width: 60, height: 60)
        static let foregroundColor: Color = Color.Gray.gray500
        static let borderColor: Color = Color.Gray.gray500
        static let typhography: TypographyToken = .t2_16b
        static let borderWidth: CGFloat = LineWidth.m
    }
}

#Preview {
    VStack(alignment: .leading, spacing: Spacing.spacing7) {
        Text("Square")
            .font(.headline)
        
        HStack(spacing: Spacing.spacing5) {
            TXButton(
                shape: .square(
                    style: .lineIcon(icon: Image.Icon.Symbol.closeM),
                    size: .m,
                    state: .standard,
                    edges: [.top, .bottom, .leading]
                ),
                onTap: { }
            )
            
            TXButton(
                shape: .square(
                    style: .lineText(text: "저장"),
                    size: .m,
                    state: .standard,
                    edges: [.top, .bottom, .trailing]
                ),
                onTap: { }
            )
            
            TXButton(
                shape: .square(
                    style: .lineIcon(icon: Image.Icon.Symbol.arrow3Left),
                    size: .m,
                    state: .standard,
                    edges: [.top, .bottom, .leading, .trailing]
                ),
                onTap: { }
            )
        }
    }
    .padding(Spacing.spacing5)
    .frame(maxWidth: .infinity, alignment: .leading)
}
