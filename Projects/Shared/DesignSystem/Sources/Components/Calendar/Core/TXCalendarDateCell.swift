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
    let customBackground: AnyView?

    var body: some View {
        Text(item.text)
            .typography(style.typography)
            .foregroundStyle(textColor)
            .frame(width: style.size, height: style.size)
            .background { backgroundView }
    }
}

// MARK: - Private
private extension TXCalendarDateCell {
    var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: style.cornerRadius)
    }

    var textColor: Color {
        switch item.status {
        case .selectedFilled: style.selectedFilledTextColor
        case .selectedLine: style.selectedLineTextColor
        case .lastDate: style.lastDateTextColor
        case .completed: style.completedTextColor
        case .default: style.defaultTextColor
        }
    }

    @ViewBuilder
    var backgroundView: some View {
        switch item.status {
        case .selectedFilled:
            shape.fill(style.selectedFilledBackgroundColor)

        case .selectedLine:
            shape
                .fill(style.selectedLineBackgroundColor)
                .overlay {
                    shape.stroke(style.selectedLineBorderColor, lineWidth: style.borderWidth)
                }
            
        case .completed:
            customBackground

        case .default, .lastDate:
            EmptyView()
        }
    }
}
