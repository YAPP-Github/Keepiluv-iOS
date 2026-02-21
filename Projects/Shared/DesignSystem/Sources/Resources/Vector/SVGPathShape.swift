//
//  SVGPathShape.swift
//  SharedDesignSystem
//
//  Created by Jihun on 2/19/26.
//

import SwiftUI

struct SVGPathShape: Shape {
    private let icon: TXVector.Icon
    
    init(icon: TXVector.Icon) {
        self.icon = icon
    }
    
    func path(in rect: CGRect) -> Path {
        let basePath = SVGPathParser.path(from: icon)
        // SVG 원본 좌표계(viewBox) 크기
        let viewBox = CGRect(x: 0, y: 0, width: 18, height: 18)
        
        // rect 안에 비율 유지로 맞추기 위한 축척값(작은 축 기준)
        let scale = min(
            rect.width / viewBox.width,
            rect.height / viewBox.height
        )
        
        // scale 적용 후 실제 아이콘 렌더링 크기
        let scaledWidth = viewBox.width * scale
        let scaledHeight = viewBox.height * scale
        
        // 남는 여백의 절반만큼 이동해 중앙 정렬하기 위한 x/y 오프셋
        let tx = rect.minX + (rect.width - scaledWidth) / 2
        let ty = rect.minY + (rect.height - scaledHeight) / 2
        
        let transform = CGAffineTransform.identity
            .translatedBy(x: tx, y: ty)
            .scaledBy(x: scale, y: scale)
        
        return basePath.applying(transform)
    }
}
