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
                        .padding(.bottom, 47)

                    buttonSection
                        .padding(.horizontal, Spacing.spacing12)
                        .padding(.bottom, Spacing.spacing5)
                }
            }
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
            Text("""
                짝꿍과
                연결해 볼까요?
                """)
                .typography(.h3_22eb)
                .foregroundStyle(Color.Gray.gray500)
            Spacer()
        }
        .padding(.horizontal, Spacing.spacing9)
    }

    var illustrationSection: some View {
        Image.Illustration.invite
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 300, height: 300)
    }

    var buttonSection: some View {
        VStack(spacing: 20) {
            sendInvitationButton

            directConnectCard
        }
    }

    var sendInvitationButton: some View {
        Button {
            store.send(.sendInvitationButtonTapped)
        } label: {
            Text("초대장 보내기")
                .typography(.t2_16b)
                .foregroundStyle(Color.Common.white)
                .frame(maxWidth: .infinity)
                .frame(height: 86)
                .background(Color.Gray.gray500)
                .clipShape(RoundedRectangle(cornerRadius: Radius.s))
        }
        .buttonStyle(.plain)
    }

    var directConnectCard: some View {
        Button {
            store.send(.directConnectCardTapped)
        } label: {
            HStack(spacing: 3) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("짝꿍에게 코드를 받았다면?")
                        .typography(.c1_12r)
                        .foregroundStyle(Color.Gray.gray400)

                    (Text("직접 ")
                        .font(TypographyToken.t2_16eb.font.swiftUIFont(size: TypographyToken.t2_16eb.size))
                    + Text("연결하기")
                        .font(TypographyToken.t2_16b.font.swiftUIFont(size: TypographyToken.t2_16b.size)))
                    .foregroundStyle(Color.Gray.gray500)
                }

                Spacer()

                arrowButton
            }
            .padding(.horizontal, 25)
            .padding(.vertical, 18)
            .frame(height: 86)
            .background(Color.Common.white)
            .clipShape(RoundedRectangle(cornerRadius: Radius.s))
            .overlay(
                RoundedRectangle(cornerRadius: Radius.s)
                    .strokeBorder(Color.Gray.gray500, lineWidth: 1.2)
            )
        }
        .buttonStyle(.plain)
    }

    var arrowButton: some View {
        Image.Icon.Symbol.arrow3Right
            .resizable()
            .renderingMode(.template)
            .frame(width: 34, height: 34)
            .foregroundStyle(Color.Gray.gray500)
            .frame(width: 44, height: 44)
            .background(Color.Gray.gray50)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .strokeBorder(Color.Gray.gray500, lineWidth: LineWidth.m)
            )
    }
}
