//
//  NotificationSettingsView.swift
//  FeatureSettings
//
//  Created by Jiyong on 02/05/26.
//

import ComposableArchitecture
import FeatureSettingsInterface
import SharedDesignSystem
import SwiftUI

/// 알림 설정 화면입니다.
struct NotificationSettingsView: View {
    @Bindable var store: StoreOf<SettingsReducer>

    var body: some View {
        VStack(spacing: 0) {
            navigationBar

            ScrollView {
                notificationList
                    .padding(.top, Spacing.spacing8)
                    .padding(.horizontal, Spacing.spacing8)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.Common.white)
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Navigation Bar

private extension NotificationSettingsView {
    var navigationBar: some View {
        TXNavigationBar(style: .subTitle(title: "알림 설정", rightText: "")) { action in
            if action == .backTapped {
                store.send(.popRoute)
            }
        }
    }
}

// MARK: - Notification List

private extension NotificationSettingsView {
    var notificationList: some View {
        VStack(spacing: 0) {
            pokePushItem
            listDivider
            marketingPushItem
            listDivider
            nightMarketingPushItem
        }
        .clipShape(RoundedRectangle(cornerRadius: Radius.s))
        .overlay(
            RoundedRectangle(cornerRadius: Radius.s)
                .stroke(Color.Gray.gray500, lineWidth: LineWidth.m)
        )
    }

    var pokePushItem: some View {
        toggleItem(
            title: "찌르기 푸쉬알림",
            isOn: $store.isPokePushEnabled
        )
    }

    var marketingPushItem: some View {
        toggleItem(
            title: "마케팅 정보 푸쉬알림",
            isOn: $store.isMarketingPushEnabled
        )
    }

    var nightMarketingPushItem: some View {
        toggleItem(
            title: "야간 마케팅 정보 푸쉬알림",
            isOn: $store.isNightMarketingPushEnabled
        )
    }

    func toggleItem(
        title: String,
        isOn: Binding<Bool>
    ) -> some View {
        HStack {
            Text(title)
                .typography(.b1_14b)
                .foregroundStyle(Color.Gray.gray500)

            Spacer()

            TXToggleSwitch(isOn: isOn)
        }
        .padding(Spacing.spacing7)
        .frame(height: 64)
    }

    var listDivider: some View {
        Rectangle()
            .fill(Color.Gray.gray500)
            .frame(height: LineWidth.m)
    }
}
