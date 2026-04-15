//
//  TXCalendar+Previews.swift
//  SharedDesignSystem
//
//  Created by 정지용 on 1/22/26.
//

import SwiftUI

// MARK: - CalendarSheet Modifier Preview (Default Button)

#Preview("calendarSheet - Default") {
    CalendarSheetDefaultPreview()
}

private struct CalendarSheetDefaultPreview: View {
    @State private var showCalendar = false
    @State private var selectedDate = TXCalendarDate(year: 2026, month: 12, day: 12)

    var body: some View {
        VStack(spacing: Spacing.spacing8) {
            Text("선택된 날짜")
                .typography(.t1_18eb)

            if let day = selectedDate.day {
                Text(verbatim: "\(selectedDate.year)년 \(selectedDate.month)월 \(day)일")
                    .typography(.b1_14b)
            } else {
                Text("날짜를 선택해주세요")
                    .typography(.b1_14b)
                    .foregroundStyle(Color.Gray.gray300)
            }

            Button("캘린더 열기") {
                showCalendar = true
            }
            .buttonStyle(.borderedProminent)
        }
        .calendarSheet(
            isPresented: $showCalendar,
            selectedDate: $selectedDate,
            onComplete: { showCalendar = false }
        )
    }
}

// MARK: - CalendarSheet Modifier Preview (Custom Button)

#Preview("calendarSheet - Custom Button") {
    CalendarSheetCustomButtonPreview()
}

private struct CalendarSheetCustomButtonPreview: View {
    @State private var showCalendar = false
    @State private var selectedDate = TXCalendarDate(year: 2026, month: 12, day: 12)

    var body: some View {
        VStack(spacing: Spacing.spacing8) {
            Text("선택된 날짜")
                .typography(.t1_18eb)

            if let day = selectedDate.day {
                Text(verbatim: "\(selectedDate.year)년 \(selectedDate.month)월 \(day)일")
                    .typography(.b1_14b)
            } else {
                Text("날짜를 선택해주세요")
                    .typography(.b1_14b)
                    .foregroundStyle(Color.Gray.gray300)
            }

            Button("캘린더 열기 (커스텀 버튼)") {
                showCalendar = true
            }
            .buttonStyle(.borderedProminent)
        }
        .calendarSheet(
            isPresented: $showCalendar,
            selectedDate: $selectedDate
        ) { exitPickerModeIfNeeded in
            HStack(spacing: Spacing.spacing5) {
                TXButton(
                    shape: .rect(style: .basic(text: "버튼 이름"), size: .l, state: .line),
                    onTap: { showCalendar = false }
                )
                
                TXButton(
                    shape: .rect(style: .basic(text: "완료"), size: .l, state: .standard),
                    onTap: {
                        if !exitPickerModeIfNeeded() {
                            showCalendar = false
                        }
                    }
                )
            }
            .padding(.horizontal, Spacing.spacing8)
        }
    }
}

// MARK: - Width Comparison Preview

#Preview("TXCalendar Widths") {
    ScrollView {
        VStack(spacing: Spacing.spacing8) {
            previewSection(title: "Small", width: 320)
            previewSection(title: "Medium", width: 390)
            previewSection(title: "Large", width: 430)
        }
        .padding(Spacing.spacing7)
        .frame(maxWidth: .infinity, alignment: .top)
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
        WeeklyPagingPreview()
        TXCalendar(mode: .monthly, weeks: PreviewData.monthlyDates)
    }
    .frame(width: width)
}

private struct WeeklyPagingPreview: View {
    @State private var currentDate = TXCalendarDate(year: 2026, month: 1, day: 1)

    var body: some View {
        TXCalendar(
            mode: .weekly,
            currentDate: $currentDate,
            weeks: TXCalendarDataGenerator.generateWeekData(for: currentDate)
        )
    }
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
    static let monthlyDates: [[TXCalendarDateItem]] = [
        [
            .init(text: "26", status: .lastDate),
            .init(text: "27", status: .lastDate),
            .init(text: "28", status: .lastDate),
            .init(text: "29", status: .lastDate),
            .init(text: "30", status: .lastDate),
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
            .init(text: "1", status: .lastDate),
            .init(text: "2", status: .lastDate)
        ]
    ]
}
