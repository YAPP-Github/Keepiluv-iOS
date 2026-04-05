//
//  TXRectButton.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/15/26.
//

import SwiftUI

struct TXRectButton: View {
    let shape: TXButtonShape
    let onTap: () -> Void
    
    public var body: some View {
        if case let .rect(style, size, state) = shape {
            Button(action: onTap) {
                Text(style.text)
                    .typography(size.typhography)
                    .foregroundStyle(state.fontColor)
                    .padding(.horizontal, size.horizontalPadding)
                    .frame(maxWidth: size.width)
                    .frame(height: size.height)
                    .background(state.backgroundColor)
                    .insideBorder(
                        state.borderColor,
                        shape: RoundedRectangle(cornerRadius: size.radius),
                        lineWidth: state.borderWidth
                    )
            }
            .clipShape(RoundedRectangle(cornerRadius: size.radius))
            .padding(.horizontal, size.outHorizontalPadding)
            .padding(.vertical, size.outVerticalPadding)
            .buttonStyle(.plain)
        } else {
            EmptyView()
        }
    }
}

// MARK: - Constants
private extension TXButtonShape.TXRectStyle {
    var text: String {
        switch self {
        case .basic(let text): text
        }
    }
}

private extension TXButtonShape.TXRectSize {
    var width: CGFloat? {
        switch self {
        case .l: .infinity
        case .m: 151
        case .s: nil
        }
    }
    
    var height: CGFloat {
        switch self {
        case .l, .m: 52
        case .s: 32
        }
    }
    
    var typhography: TypographyToken {
        switch self {
        case .l, .m: .t2_16b
        case .s: .b1_14b
        }
    }
    
    var radius: CGFloat {
        switch self {
        case .l, .m: Radius.s
        case .s: Radius.xs
        }
    }
    
    var horizontalPadding: CGFloat {
        switch self {
        case .s: Spacing.spacing6
        case .l, .m: .zero
        }
    }
    
    var outHorizontalPadding: CGFloat {
        switch self {
        case .l: Spacing.spacing8
        case .m, .s: .zero
        }
    }
    
    var outVerticalPadding: CGFloat {
        switch self {
        case .l: Spacing.spacing5
        case .m, .s: .zero
        }
    }
}

private extension TXButtonShape.TXRectState {
    var borderWidth: CGFloat? {
        switch self {
        case .line: LineWidth.m
        case .disabled, .standard: nil
        }
    }
    
    var borderColor: Color {
        switch self {
        case .line: Color.Gray.gray500
        case .disabled: Color.Gray.gray100
        case .standard: .clear
        }
    }
    
    var fontColor: Color {
        switch self {
        case .line: Color.Gray.gray500
        case .disabled: Color.Gray.gray300
        case .standard: Color.Common.white
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .line: Color.Common.white
        case .disabled: Color.Gray.gray100
        case .standard: Color.Gray.gray500
        }
    }
}

#Preview {
    VStack(alignment: .leading, spacing: Spacing.spacing7) {
        VStack(alignment: .leading, spacing: Spacing.spacing3) {
            Text("L")
                .font(.headline)
            
            TXRectButton(
                shape: .rect(style: .basic(text: "버튼 이름"), size: .l, state: .standard),
                onTap: { }
            )
        }
        
        VStack(alignment: .leading, spacing: Spacing.spacing3) {
            Text("M")
                .font(.headline)
            
            TXRectButton(
                shape: .rect(style: .basic(text: "버튼 이름"), size: .m, state: .line),
                onTap: { }
            )
            
            TXRectButton(
                shape: .rect(style: .basic(text: "버튼 이름"), size: .m, state: .standard),
                onTap: { }
            )
            
            TXRectButton(
                shape: .rect(style: .basic(text: "버튼 이름"), size: .m, state: .disabled),
                onTap: { }
            )
        }
        
        VStack(alignment: .leading, spacing: Spacing.spacing3) {
            Text("S")
                .font(.headline)
            
            TXRectButton(
                shape: .rect(style: .basic(text: "버튼 이름"), size: .s, state: .line),
                onTap: { }
            )
            
            TXRectButton(
                shape: .rect(style: .basic(text: "버튼 이름"), size: .s, state: .standard),
                onTap: { }
            )
        }
    }
    .padding(Spacing.spacing5)
    .frame(maxWidth: .infinity, alignment: .leading)
}
