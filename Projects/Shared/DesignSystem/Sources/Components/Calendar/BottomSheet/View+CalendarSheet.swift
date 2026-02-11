//
//  View+CalendarSheet.swift
//  SharedDesignSystem
//
//  Created by Claude on 1/26/26.
//

import SwiftUI

// MARK: - Calendar Sheet Modifier

public extension View {
    /// 캘린더 바텀시트를 표시하는 modifier입니다. (기본 완료 버튼)
    ///
    /// ## 사용 예시
    /// ```swift
    /// @State private var showCalendar = false
    /// @State private var selectedDate = TXCalendarDate(year: 2026, month: 12)
    ///
    /// Text("날짜 선택")
    ///     .calendarSheet(
    ///         isPresented: $showCalendar,
    ///         selectedDate: $selectedDate,
    ///         onComplete: { showCalendar = false }
    ///     )
    ///
    /// // 오늘 이후 날짜 비활성화
    /// Text("날짜 선택")
    ///     .calendarSheet(
    ///         isPresented: $showCalendar,
    ///         selectedDate: $selectedDate,
    ///         onComplete: { showCalendar = false },
    ///         isDateEnabled: { item in
    ///             guard let date = item.dateComponents?.date else { return true }
    ///             return date <= Date()
    ///         }
    ///     )
    /// ```
    func calendarSheet(
        isPresented: Binding<Bool>,
        selectedDate: Binding<TXCalendarDate>,
        completeButtonText: String = "완료",
        onComplete: @escaping () -> Void,
        isDateEnabled: ((TXCalendarDateItem) -> Bool)? = nil
    ) -> some View {
        modifier(
            CalendarSheetModifier<DefaultCalendarButton>(
                isPresented: isPresented,
                selectedDate: selectedDate,
                buttonConfiguration: .default(text: completeButtonText, onComplete: onComplete),
                isDateEnabled: isDateEnabled
            )
        )
    }

    /// 캘린더 바텀시트를 표시하는 modifier입니다. (커스텀 버튼)
    ///
    /// ## 사용 예시
    /// ```swift
    /// @State private var showCalendar = false
    /// @State private var selectedDate = TXCalendarDate(year: 2026, month: 12)
    ///
    /// Text("날짜 선택")
    ///     .calendarSheet(
    ///         isPresented: $showCalendar,
    ///         selectedDate: $selectedDate
    ///     ) { exitPickerModeIfNeeded in
    ///         TXRoundedRectangleGroupButton(
    ///             config: .modal(),
    ///             layout: .calendarSheet,
    ///             actionLeft: { showCalendar = false },
    ///             actionRight: {
    ///                 if !exitPickerModeIfNeeded() { showCalendar = false }
    ///             }
    ///         )
    ///     }
    /// ```
    func calendarSheet<ButtonContent: View>(
        isPresented: Binding<Bool>,
        selectedDate: Binding<TXCalendarDate>,
        isDateEnabled: ((TXCalendarDateItem) -> Bool)? = nil,
        @ViewBuilder buttonContent: @escaping (_ exitPickerModeIfNeeded: @escaping () -> Bool) -> ButtonContent
    ) -> some View {
        modifier(
            CalendarSheetModifier(
                isPresented: isPresented,
                selectedDate: selectedDate,
                buttonConfiguration: .custom(content: buttonContent),
                isDateEnabled: isDateEnabled
            )
        )
    }
}
