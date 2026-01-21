//
//  TXCalendarLayout.swift
//  SharedDesignSystem
//
//  Created by 정지용 on 1/22/26.
//

import SwiftUI

enum TXCalendarLayout {
    static let daysInWeek = 7
    
    static func columnSpacing(
        availableWidth: CGFloat,
        horizontalPadding: CGFloat,
        cellSize: CGFloat,
        columns: Int
    ) -> CGFloat {
        guard columns > 1 else {
            return 0
        }
        
        let paddedWidth = availableWidth - horizontalPadding - horizontalPadding
        let totalCellWidth = cellSize * CGFloat(columns)
        let remainingWidth = paddedWidth - totalCellWidth
        let gapCount = CGFloat(columns - 1)
        
        return max(0, remainingWidth / gapCount)
    }
    
    static func gridColumns(
        cellSize: CGFloat,
        spacing: CGFloat,
        columns: Int
    ) -> [GridItem] {
        Array(
            repeating: GridItem(.fixed(cellSize), spacing: spacing),
            count: columns
        )
    }
    
    static func weekdayLabelHeight(_ token: TypographyToken) -> CGFloat {
        token.size + token.lineSpacing + token.lineSpacing
    }
}
