//
//  OnboardingConnectView.swift
//  FeatureOnboarding
//
//  Created by Jiyong on 01/28/26.
//

import ComposableArchitecture
import SharedDesignSystem
import SwiftUI

/// 커플 연결 온보딩 화면입니다.
public struct OnboardingConnectView: View {
    @Bindable var store: StoreOf<OnboardingConnectReducer>

    public init(store: StoreOf<OnboardingConnectReducer>) {
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

                    illustrationSection
                        .padding(.top, 40)

                    directConnectCard
                        .padding(.top, 40)
                        .padding(.horizontal, Spacing.spacing8)
                }
            }

            Spacer()

            bottomButton
                .padding(.horizontal, Spacing.spacing8)
                .padding(.vertical, Spacing.spacing5)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.Common.white)
        .sheet(isPresented: $store.isShareSheetPresented) {
            store.send(.shareSheetDismissed)
        } content: {
            ShareSheet(activityItems: [store.shareContent])
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
}

// MARK: - Subviews

private extension OnboardingConnectView {
    var titleSection: some View {
        HStack {
            Text("짝꿍과 연결해볼까요?")
                .typography(.h3_22b)
                .foregroundStyle(Color.Gray.gray500)
            Spacer()
        }
        .padding(.horizontal, Spacing.spacing9)
    }

    var illustrationSection: some View {
        Image.Illustration.connect
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding(.horizontal, 27)
    }

    var directConnectCard: some View {
        Button {
            store.send(.directConnectCardTapped)
        } label: {
            HStack(spacing: 3) {
                VStack(alignment: .leading, spacing: Spacing.spacing3) {
                    Text("짝꿍에게 코드를 받았다면?")
                        .typography(.c1_12r)
                        .foregroundStyle(Color.Gray.gray400)

                    Text("직접 연결하기")
                        .typography(.t2_16b)
                        .foregroundStyle(Color.Gray.gray500)
                }

                Spacer()

                arrowButton
            }
            .padding(.horizontal, Spacing.spacing9)
            .padding(.vertical, Spacing.spacing7)
            .frame(height: 96)
            .background(Color.Common.white)
            .insideBorder(
                Color.Gray.gray500,
                shape: RoundedRectangle(cornerRadius: Radius.s),
                lineWidth: LineWidth.m
            )
        }
        .buttonStyle(.plain)
    }

    var arrowButton: some View {
        Image.Icon.Symbol.arrow3Right
            .resizable()
            .renderingMode(.template)
            .frame(width: 24, height: 24)
            .foregroundStyle(Color.Gray.gray500)
            .frame(width: 44, height: 44)
            .background(Color.Gray.gray50)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .strokeBorder(Color.Gray.gray500, lineWidth: LineWidth.m)
            )
    }

    var bottomButton: some View {
        TXRoundedRectangleButton(
            config: .long(text: "초대장 보내기", colorStyle: .black),
            action: { store.send(.sendInvitationButtonTapped) }
        )
    }
}
