//
//  View+CalendarSheet.swift
//  SharedDesignSystem
//
//  Created by Claude on 1/26/26.
//

import SwiftUI
import UIKit

// MARK: - Calendar Sheet Modifier

public extension View {
    /// 캘린더 바텀시트를 표시하는 modifier입니다. (기본 완료 버튼)
    ///
    /// ## 사용 예시
    /// ```swift
    /// @State private var showCalendar = false
    /// @State private var selectedYear = 2026
    /// @State private var selectedMonth = 12
    /// @State private var selectedDay: Int? = nil
    ///
    /// Text("날짜 선택")
    ///     .calendarSheet(
    ///         isPresented: $showCalendar,
    ///         selectedYear: $selectedYear,
    ///         selectedMonth: $selectedMonth,
    ///         selectedDay: $selectedDay,
    ///         onComplete: { showCalendar = false }
    ///     )
    /// ```
    func calendarSheet(
        isPresented: Binding<Bool>,
        selectedYear: Binding<Int>,
        selectedMonth: Binding<Int>,
        selectedDay: Binding<Int?>,
        completeButtonText: String = "완료",
        onComplete: @escaping () -> Void
    ) -> some View {
        modifier(
            CalendarSheetModifier<DefaultCalendarButton>(
                isPresented: isPresented,
                selectedYear: selectedYear,
                selectedMonth: selectedMonth,
                selectedDay: selectedDay,
                buttonConfiguration: .default(text: completeButtonText, onComplete: onComplete)
            )
        )
    }

    /// 캘린더 바텀시트를 표시하는 modifier입니다. (커스텀 버튼)
    ///
    /// ## 사용 예시
    /// ```swift
    /// @State private var showCalendar = false
    /// @State private var selectedYear = 2026
    /// @State private var selectedMonth = 12
    /// @State private var selectedDay: Int? = nil
    ///
    /// Text("날짜 선택")
    ///     .calendarSheet(
    ///         isPresented: $showCalendar,
    ///         selectedYear: $selectedYear,
    ///         selectedMonth: $selectedMonth,
    ///         selectedDay: $selectedDay
    ///     ) {
    ///         TXRoundedRectangleGroupButton(
    ///             config: .modal(),
    ///             actionLeft: { showCalendar = false },
    ///             actionRight: { showCalendar = false }
    ///         )
    ///     }
    /// ```
    func calendarSheet<ButtonContent: View>(
        isPresented: Binding<Bool>,
        selectedYear: Binding<Int>,
        selectedMonth: Binding<Int>,
        selectedDay: Binding<Int?>,
        @ViewBuilder buttonContent: @escaping () -> ButtonContent
    ) -> some View {
        modifier(
            CalendarSheetModifier(
                isPresented: isPresented,
                selectedYear: selectedYear,
                selectedMonth: selectedMonth,
                selectedDay: selectedDay,
                buttonConfiguration: .custom(content: buttonContent)
            )
        )
    }
}

// MARK: - Button Configuration

/// 캘린더 바텀시트 버튼 설정입니다.
private enum CalendarSheetButtonConfiguration<ButtonContent: View> {
    case `default`(text: String, onComplete: () -> Void)
    case custom(content: () -> ButtonContent)
}

// MARK: - Constants

private enum CalendarSheetConstants {
    static let dismissThreshold: CGFloat = 100
    static let backdropMaxOffset: CGFloat = 400
    static let backdropMaxOpacity: Double = 0.4
    static let dragVelocityThreshold: CGFloat = 500
    static let springResponse: Double = 0.35
    static let springDamping: Double = 0.86
}

// MARK: - Calendar Sheet Modifier

private struct CalendarSheetModifier<ButtonContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    @Binding var selectedYear: Int
    @Binding var selectedMonth: Int
    @Binding var selectedDay: Int?
    let buttonConfiguration: CalendarSheetButtonConfiguration<ButtonContent>

    @State private var dragOffset: CGFloat = 0
    @State private var isVisible = false

    func body(content: Content) -> some View {
        ZStack {
            content

            // Dimmed backdrop
            Color.black
                .opacity(isVisible ? backdropOpacity : 0)
                .ignoresSafeArea()
                .allowsHitTesting(isVisible)
                .onTapGesture { dismissSheet() }

            // Bottom sheet
            VStack {
                Spacer()
                sheetContent
            }
            .offset(y: sheetOffset)
            .gesture(dragGesture)
            .allowsHitTesting(isVisible)
            .ignoresSafeArea(edges: .bottom)
        }
        .onAppear { isVisible = isPresented }
        .onChange(of: isPresented) { newValue in
            if newValue {
                dragOffset = 0
            }
            withAnimation(springAnimation) {
                isVisible = newValue
            }
        }
    }

    @ViewBuilder
    private var sheetContent: some View {
        VStack(spacing: 0) {
            // Handle area
            RoundedCorner(radius: Radius.m, corners: [.topLeft, .topRight])
                .fill(Color.Common.white)
                .frame(height: Spacing.spacing10)
                .contentShape(Rectangle())

            // Calendar content
            calendarBottomSheet
        }
        .padding(.bottom, safeAreaBottom)
        .background(Color.Common.white)
        .clipShape(RoundedCorner(radius: Radius.m, corners: [.topLeft, .topRight]))
        .transaction { $0.animation = nil }
    }

    @ViewBuilder
    private var calendarBottomSheet: some View {
        switch buttonConfiguration {
        case let .default(text, onComplete):
            TXCalendarBottomSheet(
                selectedYear: $selectedYear,
                selectedMonth: $selectedMonth,
                selectedDay: $selectedDay,
                completeButtonText: text,
                onComplete: onComplete
            )
        case let .custom(content):
            TXCalendarBottomSheet(
                selectedYear: $selectedYear,
                selectedMonth: $selectedMonth,
                selectedDay: $selectedDay,
                buttonContent: content
            )
        }
    }

    private var springAnimation: Animation {
        .spring(response: CalendarSheetConstants.springResponse, dampingFraction: CalendarSheetConstants.springDamping)
    }

    private var backdropOpacity: Double {
        let progress = min(max(dragOffset / CalendarSheetConstants.backdropMaxOffset, 0), 1)
        return CalendarSheetConstants.backdropMaxOpacity * (1 - progress)
    }

    private var hiddenOffset: CGFloat {
        UIScreen.main.bounds.height
    }

    private var sheetOffset: CGFloat {
        (isVisible ? 0 : hiddenOffset) + dragOffset
    }

    private var safeAreaBottom: CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            return 0
        }
        return window.safeAreaInsets.bottom
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                if value.translation.height > 0 {
                    dragOffset = value.translation.height
                }
            }
            .onEnded { value in
                let velocity = value.predictedEndTranslation.height - value.translation.height
                let shouldDismiss = value.translation.height > CalendarSheetConstants.dismissThreshold
                    || velocity > CalendarSheetConstants.dragVelocityThreshold

                if shouldDismiss {
                    dismissSheet()
                } else {
                    withAnimation(springAnimation) {
                        dragOffset = 0
                    }
                }
            }
    }

    private func dismissSheet() {
        isPresented = false
    }
}

// MARK: - Rounded Corner Shape

private struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
