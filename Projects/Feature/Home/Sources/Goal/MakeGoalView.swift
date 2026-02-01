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
    }
}

// MARK: - SubViews
private extension MakeGoalView {
    var navigationBar: some View {
        TXNavigationBar(
            style: .subTitle(
                title: "직접 만들기",
                rightText: ""
            )
        )
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
            Text("반복 주기")
                .typography(.b1_14b)
            
            HStack(spacing: 8) {
                TXTabGroup(config: .period()) { period in
                    store.send(.periodSelected)
                }
                
                Spacer()
            }
        }
        .padding(.vertical, 16)
    }
    
    var startDateRow: some View {
        HStack(spacing: 8) {
            Text("시작일")
                .typography(.b1_14b)
            
            Spacer()
            
            Text("2월 1일")
                .typography(.b2_14r)
            
            Button {
                store.send(.startDateTapped)
            } label: {
                Image.Icon.Symbol.arrow2Down
            }
        }
        .padding(.vertical, 21.5)
    }
    
    var endDateToggleRow: some View {
        HStack(spacing: 0) {
            Text("종료일 설정")
                .typography(.b1_14b)
            
            Spacer()
            
            TXToggleSwitch(isOn: $store.isEndDateOn)
        }
        .padding(.vertical, 21.5)
    }
    
    var endDateRow: some View {
        HStack(spacing: 8) {
            Text("종료일")
                .typography(.b1_14b)
            
            Spacer()
            
            Text("2월 1일")
                .typography(.b2_14r)
            
            Button {
                store.send(.endDateTapped)
            } label: {
                Image.Icon.Symbol.arrow2Down
            }
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
}

#Preview {
    MakeGoalView(
        store: Store(
            initialState: MakeGoalReducer
                .State(
                    category: .book,
                    mode: .add
                ),
            reducer: {
                MakeGoalReducer()
            }
        )
    )
}
