//
//  TXRoundButton.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/15/26.
//

import SwiftUI

struct TXRoundButton: View {
    let shape: TXButtonShape
    let onTap: () -> Void
    
    public var body: some View {
        if case let .round(style, size, _) = shape {
            Button(action: onTap) {
                ZStack {
                    Capsule()
                        .fill(style.backgroundColor)
                        .frame(maxWidth: size.frameWidth)
                        .frame(height: size.backgroundHeight)
                        .padding(.top, size.yOffset)
                    
                    Text(style.text)
                        .typography(size.typography)
                        .foregroundStyle(style.fontColor)
                        .frame(maxWidth: size.frameWidth)
                        .frame(height: size.foregroundHeight)
                        .insideBorder(
                            style.borderColor,
                            shape: .capsule,
                            lineWidth: size.borderWidth
                        )
                        .background(style.foregroundColor, in: .capsule)
                }
            }
            .buttonStyle(.plain)
        } else {
            EmptyView()
        }
    }
}

// MARK: - Constants
private extension TXButtonShape.TXRoundStyle {
    var text: String {
        switch self {
        case let .illustLight(text), let .lillustDark(text): text
        }
    }
    
    var foregroundColor: Color {
        switch self {
        case .illustLight: Color.Common.white
        case .lillustDark: Color.Gray.gray500
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .illustLight: Color.Gray.gray500
        case .lillustDark: Color.Common.white
        }
    }
    
    var fontColor: Color {
        switch self {
        case .illustLight: Color.Gray.gray500
        case .lillustDark: Color.Common.white
        }
    }
    
    var borderColor: Color {
        switch self {
        case .illustLight: Color.Gray.gray500
        case .lillustDark: Color.Common.white
        }
    }
}

private extension TXButtonShape.TXRoundSize {
    var typography: TypographyToken {
        switch self {
        case .l, .m: .t2_16b
        case .s: .c2_11b
        }
    }
    
    var frameWidth: CGFloat {
        switch self {
        case .l: .infinity
        case .m: 150
        case .s: 64
        }
    }
    
    var foregroundHeight: CGFloat {
        switch self {
        case .l, .m: 68
        case .s: 28
        }
    }
    
    var backgroundHeight: CGFloat {
        switch self {
        case .l, .m: 70
        case .s: 31
        }
    }
    
    var yOffset: CGFloat {
        switch self {
        case .l, .m: 4
        case .s: 1
        }
    }
    
    var borderWidth: CGFloat {
        switch self {
        case .l, .m: 1.6
        case .s: 1
        }
    }
}


#Preview {
    VStack(alignment: .leading, spacing: Spacing.spacing7) {
        Text("Round")
            .font(.headline)
        
        VStack(alignment: .leading, spacing: Spacing.spacing3) {
            TXButton(
                shape: .round(
                    style: .illustLight(text: "버튼 이름"),
                    size: .l,
                    state: .standard
                ),
                onTap: { }
            )
            
            TXButton(
                shape: .round(
                    style: .lillustDark(text: "버튼 이름"),
                    size: .l,
                    state: .standard
                ),
                onTap: { }
            )
        }
        
        HStack(spacing: Spacing.spacing5) {
            TXButton(
                shape: .round(
                    style: .illustLight(text: "중간 버튼"),
                    size: .m,
                    state: .standard
                ),
                onTap: { }
            )
            
            TXButton(
                shape: .round(
                    style: .lillustDark(text: "중간 버튼"),
                    size: .m,
                    state: .standard
                ),
                onTap: { }
            )
        }
        
        HStack(spacing: Spacing.spacing5) {
            TXButton(
                shape: .round(
                    style: .illustLight(text: "작게"),
                    size: .s,
                    state: .standard
                ),
                onTap: { }
            )
            
            TXButton(
                shape: .round(
                    style: .lillustDark(text: "작게"),
                    size: .s,
                    state: .standard
                ),
                onTap: { }
            )
        }
    }
    .padding(Spacing.spacing5)
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    .background(Color.Gray.gray200)
}
