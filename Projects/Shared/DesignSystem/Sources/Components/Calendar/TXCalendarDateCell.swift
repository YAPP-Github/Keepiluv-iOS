//
//  TXCalendarDateCell.swift
//  SharedDesignSystem
//
//  Created by 정지용 on 1/22/26.
//

import SwiftUI

struct TXCalendarDateCell: View {
    let item: TXCalendarDateItem
    let style: TXCalendarDateStyle
    
    var body: some View {
        ZStack {
            if item.status == .selectedFilled {
                shape
                    .fill(style.selectedFilledBackgroundColor)
            }
            
            if item.status == .selectedLine {
                shape
                    .fill(style.selectedLineBackgroundColor)
                
                shape
                    .stroke(style.selectedLineBorderColor, lineWidth: style.borderWidth)
            }
            
            Text(item.text)
                .typography(style.typography)
                .foregroundStyle(textColor)
        }
        .frame(
            width: style.size,
            height: style.size
        )
    }
}

private extension TXCalendarDateCell {
    var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: style.cornerRadius)
    }
    
    var textColor: Color {
        switch item.status {
        case .selectedFilled:
            return style.selectedFilledTextColor
            
        case .lastMonth:
            return style.lastMonthTextColor
            
        case .selectedLine:
            return style.selectedLineTextColor
            
        case .default:
            return style.defaultTextColor
        }
    }
}
