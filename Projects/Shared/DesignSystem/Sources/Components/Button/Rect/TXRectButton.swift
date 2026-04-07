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
                    .typography(style.typography ?? size.typhography)
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
        case .basic(let text, _): text
        }
    }
    
    var typography: TypographyToken? {
        switch self {
        case .basic(_, let typography): typography
        }
    }
}

private extension TXButtonShape.TXRectSize {
    var width: CGFloat? {
        switch self {
        case .l: .infinity
        case .m: 151
        case .s: 56
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
        case let .custom(_, _, _, borderWidth): borderWidth
        }
    }
    
    var borderColor: Color {
        switch self {
        case .line: Color.Gray.gray500
        case .disabled: Color.Gray.gray100
        case .standard: .clear
        case let .custom(_, _, borderColor, _): borderColor
        }
    }
    
    var fontColor: Color {
        switch self {
        case .line: Color.Gray.gray500
        case .disabled: Color.Gray.gray300
        case .standard: Color.Common.white
        case let .custom(foregroundColor, _, _, _): foregroundColor
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .line: Color.Common.white
        case .disabled: Color.Gray.gray100
        case .standard: Color.Gray.gray500
        case let .custom(_, backgroundColor, _, _): backgroundColor
        }
    }
}

#Preview {
    VStack(alignment: .leading, spacing: Spacing.spacing7) {
        VStack(alignment: .leading, spacing: Spacing.spacing3) {
            Text("L")
                .font(.headline)
            
            TXButton(
                shape: .rect(style: .basic(text: "버튼 이름"), size: .l, state: .standard),
                onTap: { }
            )
        }
        
        VStack(alignment: .leading, spacing: Spacing.spacing3) {
            Text("M")
                .font(.headline)
            
            TXButton(
                shape: .rect(style: .basic(text: "버튼 이름"), size: .m, state: .line),
                onTap: { }
            )
            
            TXButton(
                shape: .rect(style: .basic(text: "버튼 이름"), size: .m, state: .standard),
                onTap: { }
            )
            
            TXButton(
                shape: .rect(style: .basic(text: "버튼 이름"), size: .m, state: .disabled),
                onTap: { }
            )
        }
        
        VStack(alignment: .leading, spacing: Spacing.spacing3) {
            Text("S")
                .font(.headline)
            
            TXButton(
                shape: .rect(style: .basic(text: "버튼 이름"), size: .s, state: .line),
                onTap: { }
            )
            
            TXButton(
                shape: .rect(style: .basic(text: "버튼 이름"), size: .s, state: .standard),
                onTap: { }
            )
        }
    }
    .padding(Spacing.spacing5)
    .frame(maxWidth: .infinity, alignment: .leading)
}
