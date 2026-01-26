//
//  TXCalendarBottomSheet.swift
//  SharedDesignSystem
//
//  Created by Claude on 1/26/26.
//

import SwiftUI

/// 캘린더 바텀시트 컴포넌트입니다.
///
/// ## 기본 사용 예시 (완료 버튼)
/// ```swift
/// TXCalendarBottomSheet(
///     selectedYear: $year,
///     selectedMonth: $month,
///     selectedDay: $day,
///     onComplete: { dismiss() }
/// )
/// ```
///
/// ## 커스텀 버튼 사용 예시
/// ```swift
/// TXCalendarBottomSheet(
///     selectedYear: $year,
///     selectedMonth: $month,
///     selectedDay: $day
/// ) {
///     TXRoundedRectangleGroupButton(
///         config: .modal(),
///         actionLeft: { /* 취소 */ },
///         actionRight: { /* 완료 */ }
///     )
/// }
/// ```
public struct TXCalendarBottomSheet<ButtonContent: View>: View {
    @Binding private var selectedYear: Int
    @Binding private var selectedMonth: Int
    @Binding private var selectedDay: Int?
    @State private var isDatePickerMode = false

    private let buttonContent: () -> ButtonContent
    private let completeButtonText: String?
    private let onComplete: (() -> Void)?

    /// 커스텀 버튼을 사용하는 이니셜라이저입니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// TXCalendarBottomSheet(
    ///     selectedYear: $year,
    ///     selectedMonth: $month,
    ///     selectedDay: $day
    /// ) {
    ///     TXRoundedRectangleGroupButton(
    ///         config: .modal(),
    ///         actionLeft: { /* 취소 */ },
    ///         actionRight: { /* 완료 */ }
    ///     )
    /// }
    /// ```
    public init(
        selectedYear: Binding<Int>,
        selectedMonth: Binding<Int>,
        selectedDay: Binding<Int?>,
        @ViewBuilder buttonContent: @escaping () -> ButtonContent
    ) {
        self._selectedYear = selectedYear
        self._selectedMonth = selectedMonth
        self._selectedDay = selectedDay
        self.buttonContent = buttonContent
        self.completeButtonText = nil
        self.onComplete = nil
    }

    public var body: some View {
        VStack(spacing: 0) {
            // MonthNavigation + Calendar
            VStack(spacing: Spacing.spacing9) {
                TXCalendarMonthNavigation(
                    title: String(format: "%d.%02d", selectedYear, selectedMonth),
                    onTitleTap: { isDatePickerMode.toggle() },
                    onPrevious: { goToPreviousMonth() },
                    onNext: { goToNextMonth() }
                )

                if isDatePickerMode {
                    datePickerView
                } else {
                    TXCalendar(
                        mode: .monthly,
                        weeks: TXCalendarDataGenerator.generateMonthData(
                            year: selectedYear,
                            month: selectedMonth,
                            selectedDay: selectedDay
                        ),
                        config: .init(
                            monthlyHeaderSpacing: Spacing.spacing7,
                            monthlyRowSpacing: Spacing.spacing6
                        )
                    ) { item in
                        if let day = Int(item.text), item.status != .lastMonth {
                            selectedDay = day
                        }
                    }
                }
            }
            .padding(.bottom, 40)

            // 버튼 영역 - 커스텀 버튼은 자체 padding 사용
            buttonArea
                .environment(\.txButtonGroupLayout, .calendarSheet)
        }
        .frame(maxWidth: .infinity)
        .background(Color.Common.white)
    }
}

// MARK: - Default Button Initializer
public extension TXCalendarBottomSheet where ButtonContent == DefaultCalendarButton {
    /// 기본 완료 버튼을 사용하는 이니셜라이저
    ///
    /// ## 사용 예시
    /// ```swift
    /// TXCalendarBottomSheet(
    ///     selectedYear: $year,
    ///     selectedMonth: $month,
    ///     selectedDay: $day,
    ///     completeButtonText: "완료",
    ///     onComplete: { dismiss() }
    /// )
    /// ```
    init(
        selectedYear: Binding<Int>,
        selectedMonth: Binding<Int>,
        selectedDay: Binding<Int?>,
        completeButtonText: String = "완료",
        onComplete: @escaping () -> Void
    ) {
        self._selectedYear = selectedYear
        self._selectedMonth = selectedMonth
        self._selectedDay = selectedDay
        self.buttonContent = {
            DefaultCalendarButton(text: completeButtonText, action: onComplete)
        }
        self.completeButtonText = completeButtonText
        self.onComplete = onComplete
    }
}

/// 기본 완료 버튼 뷰
public struct DefaultCalendarButton: View {
    let text: String
    let action: () -> Void

    public var body: some View {
        TXRoundedRectangleButton(
            config: .long(text: text, colorStyle: .black),
            action: action
        )
        .padding(.horizontal, Spacing.spacing8)
        .padding(.vertical, Spacing.spacing4)
    }
}

// MARK: - Private Views
private extension TXCalendarBottomSheet {
    @ViewBuilder
    var buttonArea: some View {
        if let completeButtonText, let onComplete {
            DefaultCalendarButton(text: completeButtonText) {
                if isDatePickerMode {
                    isDatePickerMode = false
                } else {
                    onComplete()
                }
            }
        } else {
            buttonContent()
                .environment(
                    \.txCalendarExitPickerModeIfNeeded,
                    TXCalendarExitPickerModeAction {
                        if isDatePickerMode {
                            isDatePickerMode = false
                            return true
                        }
                        return false
                    }
                )
        }
    }

    var datePickerView: some View {
        HStack(spacing: 0) {
            Picker("Year", selection: $selectedYear) {
                ForEach(2026...2099, id: \.self) { year in
                    Text(verbatim: "\(year)년").tag(year)
                }
            }
            .pickerStyle(.wheel)

            Picker("Month", selection: $selectedMonth) {
                ForEach(1...12, id: \.self) { month in
                    Text(verbatim: "\(month)월").tag(month)
                }
            }
            .pickerStyle(.wheel)
        }
        .frame(height: 250)
        .padding(.horizontal, Spacing.spacing7)
    }
}

// MARK: - Month Navigation

private extension TXCalendarBottomSheet {
    func goToPreviousMonth() {
        if selectedMonth == 1 {
            selectedMonth = 12
            selectedYear -= 1
        } else {
            selectedMonth -= 1
        }
        selectedDay = nil
    }

    func goToNextMonth() {
        if selectedMonth == 12 {
            selectedMonth = 1
            selectedYear += 1
        } else {
            selectedMonth += 1
        }
        selectedDay = nil
    }
}
