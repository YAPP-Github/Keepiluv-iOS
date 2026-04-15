//
//  TXCircleButton.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 4/3/26.
//

import SwiftUI

struct TXCircleButton: View {
    let shape: TXButtonShape
    let onTap: () -> Void
    
    public var body: some View {
        if case let .circle(style, size, state) = shape {
            Button(action: onTap) {
                style.icon
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(state.foregroundColor)
                    .frame(width: style.iconSize(for: size).width, height: style.iconSize(for: size).height)
                    .frame(width: style.frameSize(for: size).width, height: style.frameSize(for: size).height)
                    .background(state.backgroundColor(style: style), in: .circle)
                    .insideBorder(
                        state.borderColor,
                        shape: Circle(),
                        lineWidth: state.borderWidth
                    )
                    .shadow(
                        color: style.shadowColor,
                        radius: style.shadowRadius
                    )
            }
            .buttonStyle(.plain)
            .disabled(state.isDisabled)
        } else {
            EmptyView()
        }
    }
}

// MARK: Constants
private extension TXButtonShape.TXCircleStyle {
    var icon: Image {
        switch self {
        case let .basic(icon), let .glass(icon):
            icon
        }
    }
    
    func frameSize(for size: TXButtonShape.TXCircleSize) -> CGSize {
        switch (self, size) {
        case let (_, .custom(frameSize, _)): frameSize
        case (.basic, .m): CGSize(width: 56, height: 56)
        case (.basic, .s): CGSize(width: 28, height: 28)
        case (.glass, .m): CGSize(width: 44, height: 44)
        case (.glass, .s): CGSize(width: 28, height: 28)
        }
    }
    
    func iconSize(for size: TXButtonShape.TXCircleSize) -> CGSize {
        switch (self, size) {
        case let (_, .custom(_, iconSize)): iconSize
        case (.basic, .m): CGSize(width: 44, height: 44)
        case (.basic, .s): CGSize(width: 24, height: 24)
        case (.glass, .m), (.glass, .s): CGSize(width: 24, height: 24)
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .basic: Color.Gray.gray500
        case .glass: Color.Common.white.opacity(0.1)
        }
    }
    
    var shadowColor: Color {
        switch self {
        case .basic: Color.clear
        case .glass: Color.black.opacity(0.1)
        }
    }
    
    var shadowRadius: CGFloat {
        switch self {
        case .basic: .zero
        case .glass: 10
        }
    }
}

private extension TXButtonShape.TXCircleState {
    var foregroundColor: Color {
        switch self {
        case .line: Color.Gray.gray500
        case .disabled: Color.Gray.gray300
        case .standard: Color.Common.white
        case let .custom(foregroundColor, _, _, _, _): foregroundColor
        }
    }
    
    var borderColor: Color {
        switch self {
        case .line: Color.Gray.gray500
        case .disabled: Color.Gray.gray100
        case .standard: Color.clear
        case let .custom(_, _, borderColor, _, _): borderColor
        }
    }
    
    var borderWidth: CGFloat? {
        switch self {
        case .line: LineWidth.m
        case .disabled, .standard: nil
        case let .custom(_, _, _, borderWidth, _): borderWidth
        }
    }
    
    func backgroundColor(style: TXButtonShape.TXCircleStyle) -> Color {
        switch self {
        case .line: Color.Common.white
        case .disabled: Color.Gray.gray100
        case .standard: style.backgroundColor
        case let .custom(_, backgroundColor, _, _, _): backgroundColor
        }
    }
    
    var isDisabled: Bool {
        switch self {
        case .disabled: true
        case .line, .standard: false
        case let .custom(_, _, _, _, isDisabled): isDisabled
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    VStack(spacing: Spacing.spacing5) {
        TXButton(
            shape: .circle(
                style: .basic(icon: Image.Icon.Symbol.plus),
                size: .m,
                state: .standard
            ),
            onTap: { }
        )
        
        TXButton(
            shape: .circle(
                style: .glass(icon: Image.Icon.Symbol.flash),
                size: .m,
                state: .standard
            ),
            onTap: { }
        )
        
        TXButton(
            shape: .circle(
                style: .basic(icon: Image.Icon.Symbol.plus),
                size: .s,
                state: .line
            ),
            onTap: { }
        )
    }
    .padding(Spacing.spacing5)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.gray)
}
