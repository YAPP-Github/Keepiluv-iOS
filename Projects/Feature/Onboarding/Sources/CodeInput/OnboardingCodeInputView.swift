//
//  OnboardingCodeInputView.swift
//  FeatureOnboarding
//
//  Created by Jiyong on 01/28/26.
//

import ComposableArchitecture
import SharedDesignSystem
import SwiftUI

/// 커플 연결 초대 코드 입력 화면입니다.
public struct OnboardingCodeInputView: View {
    @Bindable var store: StoreOf<OnboardingCodeInputReducer>
    @FocusState private var isTextFieldFocused: Bool

    public init(store: StoreOf<OnboardingCodeInputReducer>) {
        self.store = store
    }

    public var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 0) {
                    titleSection
                        .padding(.top, 72)
                        .padding(.horizontal, Spacing.spacing9)
                        .padding(.bottom, 92)

                    bodySection
                        .padding(.horizontal, 36)
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
        .onTapGesture {
            isTextFieldFocused = false
        }
        .txToast(item: $store.toast)
    }
}

// MARK: - Subviews

private extension OnboardingCodeInputView {
    var titleSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("""
                    짝꿍에게 받은
                    초대 코드를 써주세요
                    """)
                    .typography(.h3_22eb)
                    .foregroundStyle(Color.Gray.gray500)
            }
            Spacer()
        }
    }

    var bodySection: some View {
        VStack(spacing: 52) {
            myInviteCodeCard
            receivedCodeSection
        }
    }

    var myInviteCodeCard: some View {
        VStack(spacing: Spacing.spacing4) {
            Text("내 초대 코드")
                .typography(.b3_12eb)
                .foregroundStyle(Color.Gray.gray400)

            HStack(spacing: Spacing.spacing5) {
                Spacer()

                Text(store.myInviteCode)
                    .typography(.h1_28b)
                    .foregroundStyle(Color.Gray.gray500)

                copyButton

                Spacer()
            }
        }
        .padding(.vertical, Spacing.spacing8)
        .frame(maxWidth: .infinity)
        .background(Color.Common.white)
        .insideBorder(
            Color.Gray.gray200,
            shape: RoundedRectangle(cornerRadius: Radius.s),
            lineWidth: LineWidth.m
        )
    }

    var copyButton: some View {
        Button {
            store.send(.copyMyCodeButtonTapped)
        } label: {
            Image.Icon.Symbol.copy
                .resizable()
                .renderingMode(.template)
                .frame(width: 24, height: 24)
                .foregroundStyle(Color.Gray.gray300)
                .padding(Spacing.spacing1)
                .background(Color.Gray.gray50)
                .clipShape(RoundedRectangle(cornerRadius: Radius.xs))
        }
        .buttonStyle(.plain)
    }

    var receivedCodeSection: some View {
        VStack(spacing: Spacing.spacing6) {
            Text("받은 코드 쓰기")
                .typography(.b3_12eb)
                .foregroundStyle(Color.Gray.gray500)

            codeInputFields
        }
    }

    var codeInputFields: some View {
        ZStack {
            hiddenTextField

            HStack {
                ForEach(0..<OnboardingCodeInputReducer.State.codeLength, id: \.self) { index in
                    codeInputCell(at: index)
                }
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            .onTapGesture {
                store.send(.codeFieldTapped)
                isTextFieldFocused = true
            }
        }
    }

    var hiddenTextField: some View {
        TextField(
            "",
            text: Binding(
                get: { store.receivedCode },
                set: { store.send(.codeInputChanged($0)) }
            )
        )
        .keyboardType(.asciiCapable)
        .textInputAutocapitalization(.characters)
        .focused($isTextFieldFocused)
        .frame(width: 1, height: 1)
        .opacity(0.01)
        .allowsHitTesting(false)
    }

    func codeInputCell(at index: Int) -> some View {
        let character = store.codeCharacters[index]
        let isFocused = store.focusedIndex == index && isTextFieldFocused
        let isFilled = character != nil

        return ZStack {
            RoundedRectangle(cornerRadius: Radius.xs)
                .fill(Color.Common.white)
                .insideBorder(
                    isFocused ? Color.Gray.gray500 : Color.Gray.gray200,
                    shape: RoundedRectangle(cornerRadius: Radius.xs),
                    lineWidth: LineWidth.m
                )

            if let char = character {
                Text(String(char))
                    .typography(.h3_22eb)
                    .foregroundStyle(Color.Gray.gray500)
            }

            if isFocused && !isFilled {
                cursor
            }
        }
        .frame(width: 36, height: 58)
    }

    var cursor: some View {
        Rectangle()
            .fill(Color.Gray.gray500)
            .frame(width: 2, height: 28)
            .clipShape(Capsule())
    }

    var bottomButton: some View {
        TXRoundedRectangleButton(
            config: .long(
                text: "완료",
                colorStyle: store.isCodeComplete ? .black : .disabled
            ),
            action: { store.send(.completeButtonTapped) }
        )
        .disabled(!store.isCodeComplete)
    }
}
