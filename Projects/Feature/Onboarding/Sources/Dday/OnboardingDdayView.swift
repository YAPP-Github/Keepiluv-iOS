//
//  OnboardingDdayView.swift
//  FeatureOnboarding
//
//  Created by Claude on 01/29/26.
//

import ComposableArchitecture
import SharedDesignSystem
import SwiftUI

/// 기념일 등록 화면입니다.
public struct OnboardingDdayView: View {
    @Bindable var store: StoreOf<OnboardingDdayReducer>

    public init(store: StoreOf<OnboardingDdayReducer>) {
        self.store = store
    }

    public var body: some View {
        VStack(spacing: 0) {
            TXNavigationBar(style: .iconOnly(.back)) { action in
                if action == .backTapped {
                    store.send(.backButtonTapped)
                }
            }

            ScrollView {
                VStack(spacing: 0) {
                    titleSection
                        .padding(.horizontal, Spacing.spacing9)
                        .padding(.bottom, 32)

                    dateSelectorSection
                        .padding(.horizontal, Spacing.spacing8)
                }
            }
            .scrollDismissesKeyboard(.interactively)

            Spacer()

            bottomButton
                .padding(.horizontal, Spacing.spacing8)
                .padding(.vertical, Spacing.spacing5)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.Common.white)
        .calendarSheet(
            isPresented: $store.showCalendarSheet,
            selectedDate: $store.selectedDate,
            onComplete: { store.send(.calendarCompleted) }
        )
    }
}

// MARK: - Subviews

private extension OnboardingDdayView {
    var titleSection: some View {
        HStack {
            Text("우리 커플의 기념일은?")
                .typography(.h3_22b)
                .foregroundStyle(Color.Gray.gray500)
            Spacer()
        }
    }

    var dateSelectorSection: some View {
        Button {
            store.send(.dateSelectorTapped)
        } label: {
            dateSelectorContent
        }
        .buttonStyle(.plain)
    }

    var dateSelectorContent: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                dateText
                    .padding(.leading, Spacing.spacing5)

                Spacer()

                calendarIcon
                    .padding(.horizontal, 10)
            }
            .padding(.vertical, Spacing.spacing3)

            underline
        }
    }

    var dateText: some View {
        Group {
            if let formattedDate = store.formattedDate {
                Text(formattedDate)
                    .typography(.t2_16b)
                    .foregroundStyle(Color.Gray.gray500)
            } else {
                Text("YYYY-MM-DD")
                    .typography(.t2_16b)
                    .foregroundStyle(Color.Gray.gray200)
            }
        }
        .opacity(0.8)
    }

    var calendarIcon: some View {
        Image.Icon.Symbol.calendar
            .resizable()
            .frame(width: 24, height: 24)
            .padding(2)
            .frame(width: 44, height: 44)
    }

    var underline: some View {
        Rectangle()
            .foregroundStyle(Color.Gray.gray500)
            .frame(height: 1)
    }

    var bottomButton: some View {
        TXRoundedRectangleButton(
            config: .long(
                text: "완료",
                colorStyle: store.isDateSelected ? .black : .disabled
            ),
            action: { store.send(.completeButtonTapped) }
        )
    }
}
