//
//  OnboardingProfileView.swift
//  FeatureOnboarding
//
//  Created by Jiyong on 01/28/26.
//

import ComposableArchitecture
import SharedDesignSystem
import SwiftUI

/// 프로필 설정(닉네임 입력) 화면입니다.
public struct OnboardingProfileView: View {
    @Bindable var store: StoreOf<OnboardingProfileReducer>
    @FocusState private var isTextFieldFocused: Bool

    public init(store: StoreOf<OnboardingProfileReducer>) {
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
                        .padding(.bottom, Constants.titleBodySpacing)

                    textFieldSection
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
        .contentShape(Rectangle())
        .onTapGesture {
            isTextFieldFocused = false
        }
        .txToast(
            isPresented: Binding(
                get: { store.showToast },
                set: { _ in store.send(.toastDismissed) }
            ),
            style: .fit,
            message: Constants.toastMessage,
            position: .bottom
        )
    }
}

// MARK: - Subviews

private extension OnboardingProfileView {
    var titleSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("""
                    짝꿍에게 보일
                    내 이름을 등록하세요!
                    """)
                    .typography(.h3_22b)
                    .foregroundStyle(Color.Gray.gray500)
            }
            Spacer()
        }
    }

    var textFieldSection: some View {
        VStack(alignment: .leading, spacing: Spacing.spacing5) {
            TXTextField(
                text: $store.nickname,
                placeholderText: "닉네임을 입력해 주세요.",
                isFocused: $isTextFieldFocused
            )

            validationSubText
        }
    }

    var validationSubText: some View {
        HStack(spacing: Spacing.spacing3) {
            Image.Icon.Symbol.check
                .resizable()
                .renderingMode(.template)
                .frame(width: 14, height: 14)
                .foregroundStyle(validationColor)

            Text("닉네임 2-8자")
                .typography(.c2_11b)
                .foregroundStyle(validationColor)
        }
    }

    var validationColor: Color {
        if store.nickname.isEmpty {
            return Color.Gray.gray300
        } else if store.isNicknameValid {
            return Color.Status.success
        } else {
            return Color.Status.warning
        }
    }

    var bottomButton: some View {
        TXRoundedRectangleButton(
            config: .long(
                text: "완료",
                colorStyle: store.isNicknameValid ? .black : .disabled
            ),
            action: { store.send(.completeButtonTapped) }
        )
    }
}

// MARK: - Constants

private extension OnboardingProfileView {
    enum Constants {
        static let titleBodySpacing: CGFloat = 32
        static let textFieldHeight: CGFloat = 44
        static let toastMessage = "2자에서 8자 이내로 닉네임을 입력해주세요."
    }
}
