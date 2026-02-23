//
//  TXCheckboxModalView.swift
//  SharedDesignSystem
//

import SwiftUI

/// 체크박스 옵션이 있는 모달 뷰입니다.
public struct TXCheckboxModalView: View {
    public struct Option: Identifiable {
        public let id: Int
        public let label: String
        public let initialValue: Bool

        public init(id: Int, label: String, initialValue: Bool = true) {
            self.id = id
            self.label = label
            self.initialValue = initialValue
        }
    }

    private let title: String
    private let options: [Option]
    private let description: String?
    private let onConfirm: ([Int: Bool]) -> Void

    @State private var selections: [Int: Bool]

    public init(
        title: String,
        options: [Option],
        description: String? = nil,
        onConfirm: @escaping ([Int: Bool]) -> Void
    ) {
        self.title = title
        self.options = options
        self.description = description
        self.onConfirm = onConfirm

        var initialSelections: [Int: Bool] = [:]
        for option in options {
            initialSelections[option.id] = option.initialValue
        }
        self._selections = State(initialValue: initialSelections)
    }

    public var body: some View {
        ZStack {
            dimBackground
            modalContent
        }
    }
}

// MARK: - SubViews

private extension TXCheckboxModalView {
    var dimBackground: some View {
        Color.Dimmed.dimmed70
            .ignoresSafeArea()
    }

    var modalContent: some View {
        VStack(spacing: 0) {
            contentContainer
            buttonContainer
        }
        .frame(width: 350)
        .background(
            RoundedRectangle(cornerRadius: Radius.m)
                .fill(Color.Common.white)
        )
    }

    var contentContainer: some View {
        VStack(spacing: Spacing.spacing9) {
            titleSection
            optionsSection
        }
        .padding(.top, Spacing.spacing8)
        .padding(.horizontal, Spacing.spacing8)
    }

    var titleSection: some View {
        Text(title)
            .typography(.t1_18eb)
            .foregroundStyle(Color.Gray.gray500)
            .multilineTextAlignment(.center)
    }

    var optionsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.spacing65) {
            optionsList
            if let description {
                descriptionText(description)
            }
        }
    }

    var optionsList: some View {
        VStack(alignment: .leading, spacing: Spacing.spacing6) {
            ForEach(options) { option in
                optionRow(option)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    func optionRow(_ option: Option) -> some View {
        Button {
            selections[option.id]?.toggle()
        } label: {
            HStack(spacing: Spacing.spacing5) {
                checkIcon(isSelected: selections[option.id] ?? option.initialValue)

                Text(option.label)
                    .typography(.b2_14r)
                    .foregroundStyle(Color.Gray.gray500)
            }
        }
        .buttonStyle(.plain)
    }

    func checkIcon(isSelected: Bool) -> some View {
        Group {
            if isSelected {
                Image.Icon.Symbol.checkYou
                    .resizable()
            } else {
                Image.Icon.Symbol.unCheckYou
                    .resizable()
            }
        }
        .frame(width: 24, height: 24)
    }

    func descriptionText(_ text: String) -> some View {
        Text(text)
            .typography(.c2_11b)
            .foregroundStyle(Color.Gray.gray300)
            .padding(.horizontal, Spacing.spacing5)
    }

    var buttonContainer: some View {
        VStack {
            confirmButton
        }
        .padding(.horizontal, Spacing.spacing8)
        .padding(.top, Spacing.spacing11)
        .padding(.bottom, Spacing.spacing8)
    }

    var confirmButton: some View {
        Button {
            onConfirm(selections)
        } label: {
            Text("확인")
                .typography(.t2_16b)
                .foregroundStyle(Color.Common.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(
                    RoundedRectangle(cornerRadius: Radius.s)
                        .fill(Color.Gray.gray500)
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    TXCheckboxModalView(
        title: "도움이 되는 정보를\n알림으로 받아보시겠어요?",
        options: [
            .init(id: 0, label: "[선택] 마케팅 정보 알림", initialValue: true),
            .init(id: 1, label: "[선택] 야간 마케팅 정보 알림", initialValue: true)
        ],
        description: "* 언제든지 설정 > 알림 설정에서 변경 가능해요",
        onConfirm: { selections in
            print("Marketing: \(selections[0] ?? false), Night: \(selections[1] ?? false)")
        }
    )
}
