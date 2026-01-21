//
//  TXCalendar+Previews.swift
//  SharedDesignSystem
//
//  Created by 정지용 on 1/22/26.
//

import SwiftUI

#Preview("TXCalendar Widths") {
    ScrollView {
        VStack(spacing: Spacing.spacing8) {
            previewSection(title: "Small", width: 320)
            previewSection(title: "Medium", width: 390)
            previewSection(title: "Large", width: 430)
        }
        .padding(Spacing.spacing7)
        .frame(
            maxWidth: .infinity,
            alignment: .top
        )
        .background(Color.Gray.gray50)
    }
}

private func previewSection(
    title: String,
    width: CGFloat
) -> some View {
    VStack(spacing: Spacing.spacing6) {
        Text(title)
            .typography(.b1_14b)
            .foregroundStyle(Color.Gray.gray500)
        
        TXCalendarWeekSelector(items: PreviewData.weekSelectorItems)
        TXCalendarMonthNavigation(title: "2026.12")
        TXCalendar(mode: .weekly, weeks: PreviewData.weeklyDates)
        TXCalendar(mode: .monthly, weeks: PreviewData.monthlyDates)
    }
    .frame(width: width)
}

private enum PreviewData {
    static let weekSelectorItems: [(weekday: String, date: TXCalendarDateItem)] = [
        (weekday: "일", date: .init(text: "11")),
        (weekday: "월", date: .init(text: "12")),
        (weekday: "화", date: .init(text: "13")),
        (weekday: "오늘", date: .init(text: "14", status: .selectedLine)),
        (weekday: "목", date: .init(text: "15")),
        (weekday: "금", date: .init(text: "16")),
        (weekday: "토", date: .init(text: "17"))
    ]
    
    static let weeklyDates: [[TXCalendarDateItem]] = [[
        .init(text: "11"),
        .init(text: "12"),
        .init(text: "13"),
        .init(text: "14", status: .selectedLine),
        .init(text: "15"),
        .init(text: "16"),
        .init(text: "17")
    ]]
    
    static let monthlyDates: [[TXCalendarDateItem]] = [
        [
            .init(text: "26", status: .lastMonth),
            .init(text: "27", status: .lastMonth),
            .init(text: "28", status: .lastMonth),
            .init(text: "29", status: .lastMonth),
            .init(text: "30", status: .lastMonth),
            .init(text: "1"),
            .init(text: "2")
        ],
        [
            .init(text: "3"),
            .init(text: "4"),
            .init(text: "5"),
            .init(text: "6"),
            .init(text: "7"),
            .init(text: "8"),
            .init(text: "9")
        ],
        [
            .init(text: "10"),
            .init(text: "11"),
            .init(text: "12", status: .selectedFilled),
            .init(text: "13"),
            .init(text: "14"),
            .init(text: "15"),
            .init(text: "16")
        ],
        [
            .init(text: "17"),
            .init(text: "18"),
            .init(text: "19"),
            .init(text: "20"),
            .init(text: "21"),
            .init(text: "22"),
            .init(text: "23")
        ],
        [
            .init(text: "24"),
            .init(text: "25"),
            .init(text: "26"),
            .init(text: "27"),
            .init(text: "28"),
            .init(text: "1", status: .lastMonth),
            .init(text: "2", status: .lastMonth)
        ]
    ]
}
