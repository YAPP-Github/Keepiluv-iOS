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
            TXNavigationBar(style: .iconOnly(.back)) { action in
                if action == .backTapped {
                    store.send(.backButtonTapped)
                }
            }

            ScrollView {
                VStack(spacing: 0) {
                    if !store.hasStartedInput {
                        titleSection
                            .padding(.horizontal, Spacing.spacing9)
                            .padding(.bottom, Constants.titleBodySpacing)
                    }

                    bodySection
                        .padding(.horizontal, Constants.horizontalPadding)
                        .padding(.top, store.hasStartedInput ? Spacing.spacing5 : 0)
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
    }
}

// MARK: - Subviews

private extension OnboardingCodeInputView {
    var titleSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("짝꿍에게 받은")
                    .typography(.h3_22b)
                    .foregroundStyle(Color.Gray.gray500)
                Text("초대 코드를 써주세요")
                    .typography(.h3_22b)
                    .foregroundStyle(Color.Gray.gray500)
            }
            Spacer()
        }
    }

    var bodySection: some View {
        VStack(spacing: Constants.sectionSpacing) {
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
                .frame(width: 12, height: 13)
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

            HStack(spacing: Spacing.spacing3) {
                ForEach(0..<OnboardingCodeInputReducer.State.codeLength, id: \.self) { index in
                    codeInputCell(at: index)
                }
            }
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
                    .typography(.h3_22b)
                    .foregroundStyle(Color.Gray.gray500)
            }

            if isFocused && !isFilled {
                cursor
            }
        }
        .frame(width: Constants.cellWidth, height: Constants.cellHeight)
    }

    var cursor: some View {
        Rectangle()
            .fill(Color.Gray.gray500)
            .frame(width: 2, height: 28)
            .clipShape(Capsule())
    }

    @ViewBuilder
    var bottomButton: some View {
        if store.isCodeComplete {
            TXRoundedRectangleButton(
                config: .long(text: "완료", colorStyle: .black),
                action: { store.send(.completeButtonTapped) }
            )
        } else {
            disabledButton
        }
    }

    var disabledButton: some View {
        Text("완료")
            .typography(.t2_16b)
            .foregroundStyle(Color.Gray.gray300)
            .frame(height: 52)
            .frame(maxWidth: .infinity)
            .background(Color.Gray.gray100, in: RoundedRectangle(cornerRadius: Radius.s))
            .insideBorder(
                Color.Gray.gray100,
                shape: RoundedRectangle(cornerRadius: Radius.s),
                lineWidth: LineWidth.m
            )
    }
}

// MARK: - Constants

private extension OnboardingCodeInputView {
    enum Constants {
        static let horizontalPadding: CGFloat = 48
        static let titleBodySpacing: CGFloat = 92
        static let sectionSpacing: CGFloat = 52
        static let cellWidth: CGFloat = 38
        static let cellHeight: CGFloat = 58
    }
}
