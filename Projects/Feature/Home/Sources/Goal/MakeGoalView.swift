//
//  MakeGoalView.swift
//  FeatureHomeInterface
//
//  Created by 정지훈 on 2/1/26.
//

import SwiftUI

import ComposableArchitecture
import FeatureHomeInterface
import SharedDesignSystem

struct MakeGoalView: View {
    
    @Bindable var store: StoreOf<MakeGoalReducer>
    
    var body: some View {
        VStack(spacing: 0) {
            navigationBar
                .padding(.horizontal, -20)
            emojiButton
                .padding(.top, 52)
            goalTitleField
                .padding(.top, 44)
            scheduleSection
                .padding(.top, 44)
            
            Spacer()
            
            completeButton
        }
        .padding(.horizontal, 20)
        .toolbar(.hidden, for: .navigationBar)
        .onDisappear { store.send(.onDisappear) }
        .txBottomSheet(
            isPresented: $store.isCalendarSheetPresented
        ) {
            TXCalendarBottomSheet(
                selectedDate: $store.calendarSheetDate,
                completeButtonText: "완료",
                onComplete: {
                    store.send(.monthCalendarConfirmTapped)
                }
            )
        }
    }
}

// MARK: - SubViews
private extension MakeGoalView {
    var navigationBar: some View {
        TXNavigationBar(
            style: .subTitle(
                title: "직접 만들기",
                rightText: ""
            )) { _ in
                store.send(.navigationBackButtonTapped)
            }
    }
    
    var emojiButton: some View {
        Button {
            store.send(.emojiButtonTapped)
        } label: {
            Image.Icon.Illustration.emojiAdd
                .padding(26)
                .background(Color.Gray.gray50, in: .circle)
                .insideBorder(
                    Color.Gray.gray500,
                    shape: .circle,
                    lineWidth: 1
                )
        }
        .buttonStyle(.plain)
    }
    
    var goalTitleField: some View {
        TXTextField(
            text: $store.goalTitle,
            placeholderText: "목표를 입력해 보세요"
        )
    }
    
    var scheduleSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            periodSection
            divider
            startDateRow
            divider
            endDateToggleRow
            
            if store.isEndDateOn {
                divider
                endDateRow
            }
        }
        .padding(.horizontal, 16)
        .insideBorder(
            Color.Gray.gray500,
            shape: RoundedRectangle(cornerRadius: 12),
            lineWidth: LineWidth.m
        )
    }
    
    var periodSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitleText("반복 주기")
            
            HStack(spacing: 8) {
                TXTabGroup(
                    selectedItem: $store.selectedPeriod,
                    config: .period()
                )
                
                Spacer()
                
                if store.showPeriodCount {
                    valueText(store.periodCountText)
                    dropDownButton { store.send(.periodSelected) }
                }
            }
        }
        .padding(.vertical, 16)
    }
    
    var startDateRow: some View {
        HStack(spacing: 8) {
            sectionTitleText("시작일")
            
            Spacer()
            
            valueText(dateText(store.startDate))
            
            dropDownButton { store.send(.startDateTapped) }
        }
        .padding(.vertical, 21.5)
    }
    
    var endDateToggleRow: some View {
        HStack(spacing: 0) {
            sectionTitleText("종료일 설정")
            
            Spacer()
            
            TXToggleSwitch(isOn: $store.isEndDateOn)
        }
        .padding(.vertical, 17)
    }
    
    var endDateRow: some View {
        HStack(spacing: 8) {
            sectionTitleText("종료일")
            
            Spacer()
            
            valueText(dateText(store.endDate))
            
            dropDownButton { store.send(.endDateTapped) }
        }
        .padding(.vertical, 21.5)
    }
    
    var completeButton: some View {
        TXRoundedRectangleButton(
            config: .long(
                text: "완료",
                colorStyle: .black
            )
        ) {
            store.send(.completeButtonTapped)
        }
    }
    
    var divider: some View {
        Color.Gray.gray500
            .frame(height: 1)
            .padding(.horizontal, -16)
    }
    
    func dropDownButton(_ action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Image.Icon.Symbol.arrow2Down
        }
    }
    
    func sectionTitleText(_ text: String) -> some View {
        Text(text)
            .typography(.b1_14b)
            .foregroundStyle(Color.Gray.gray500)
    }
    
    func valueText(_ text: String) -> some View {
        Text(text)
            .typography(.b2_14r)
            .foregroundStyle(Color.Gray.gray500)
    }

    func dateText(_ date: TXCalendarDate?) -> String {
        guard let date = date else { return "" }
        if let day = date.day {
            return "\(date.month)월 \(day)일"
        }
        return "\(date.month)월"
    }
}
