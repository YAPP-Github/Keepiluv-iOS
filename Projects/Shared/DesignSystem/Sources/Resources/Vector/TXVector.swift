//
//  TXVector.swift
//  SharedDesignSystem
//
//  Created by Jihun on 2/19/26.
//

import SwiftUI

/// SVG path 기반으로 렌더링되는 lofi 아이콘입니다.
///
/// `fillColor`와 `borderColor`를 코드에서 직접 주입할 수 있습니다.
public struct TXVector: View {
    public enum Icon: String, Sendable, CaseIterable {
        case clover
        case flower
        case heart
        case moon
        case note
    }
    
    private let icon: Icon
    private let fillColor: Color
    private let borderColor: Color
    private let borderLineWidth: CGFloat
    
    public init(
        icon: Icon,
        fillColor: Color,
        borderColor: Color,
        borderLineWidth: CGFloat = 1
    ) {
        self.icon = icon
        self.fillColor = fillColor
        self.borderColor = borderColor
        self.borderLineWidth = borderLineWidth
    }
    
    public var body: some View {
        SVGPathShape(icon: icon)
            .fill(fillColor)
            .stroke(borderColor, lineWidth: borderLineWidth)
    }
}

#Preview {
    HStack(spacing: 16) {
        ForEach(TXVector.Icon.allCases, id: \.self) { icon in
            TXVector(
                icon: icon,
                fillColor: Color.yellow,
                borderColor: Color.black
            )
            .frame(width: 28, height: 28)
        }
    }
    .padding()
}
