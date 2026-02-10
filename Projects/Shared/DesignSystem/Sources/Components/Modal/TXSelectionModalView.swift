//
//  TXSelectionModalView.swift
//  SharedDesignSystem
//
//  Created by Jiyong on 02/05/26.
//

import SwiftUI

/// 선택 옵션이 있는 모달 뷰입니다.
///
/// ## 사용 예시
/// ```swift
/// TXSelectionModalView(
///     title: "언어 설정",
///     subtitle: "이미 앱 내에 저장된 언어는 변경되지 않아요",
///     options: ["한국어", "English", "日本語"],
///     selectedIndex: $selectedIndex,
///     onCancel: { },
///     onConfirm: { }
/// )
/// ```
public struct TXSelectionModalView<Option: Hashable>: View {
    private let title: String
    private let subtitle: String?
    private let options: [Option]
    private let optionLabel: (Option) -> String
    @Binding private var selectedOption: Option
    private let onCancel: () -> Void
    private let onConfirm: () -> Void

    /// TXSelectionModalView를 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// TXSelectionModalView(
    ///     title: "언어 설정",
    ///     subtitle: "이미 앱 내에 저장된 언어는 변경되지 않아요",
    ///     options: Language.allCases,
    ///     optionLabel: { $0.displayName },
    ///     selectedOption: $selectedLanguage,
    ///     onCancel: { },
    ///     onConfirm: { }
    /// )
    /// ```
    public init(
        title: String,
        subtitle: String? = nil,
        options: [Option],
        optionLabel: @escaping (Option) -> String,
        selectedOption: Binding<Option>,
        onCancel: @escaping () -> Void,
        onConfirm: @escaping () -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.options = options
        self.optionLabel = optionLabel
        self._selectedOption = selectedOption
        self.onCancel = onCancel
        self.onConfirm = onConfirm
    }

    public var body: some View {
        ZStack {
            dimBackground

            modalContent
        }
    }
}

// MARK: - SubViews

private extension TXSelectionModalView {
    var dimBackground: some View {
        Color.Dimmed.dimmed70
            .ignoresSafeArea()
            .onTapGesture {
                onCancel()
            }
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
            optionsList
        }
        .padding(.top, Spacing.spacing8)
        .padding(.horizontal, Spacing.spacing8)
    }

    var titleSection: some View {
        VStack(spacing: Spacing.spacing5) {
            Text(title)
                .typography(.t1_18eb)
                .foregroundStyle(Color.Gray.gray500)

            if let subtitle {
                Text(subtitle)
                    .typography(.b2_14r)
                    .foregroundStyle(Color.Gray.gray500)
            }
        }
        .multilineTextAlignment(.center)
    }

    var optionsList: some View {
        VStack(alignment: .leading, spacing: Spacing.spacing8) {
            ForEach(options, id: \.self) { option in
                optionRow(option)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    func optionRow(_ option: Option) -> some View {
        Button {
            selectedOption = option
        } label: {
            HStack(spacing: Spacing.spacing5) {
                checkIcon(isSelected: selectedOption == option)

                Text(optionLabel(option))
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
        .frame(width: 28, height: 28)
    }

    var buttonContainer: some View {
        HStack(spacing: Spacing.spacing5) {
            cancelButton
            confirmButton
        }
        .padding(.horizontal, Spacing.spacing8)
        .padding(.top, Spacing.spacing11)
        .padding(.bottom, Spacing.spacing8)
    }

    var cancelButton: some View {
        Button(action: onCancel) {
            Text("취소")
                .typography(.t2_16b)
                .foregroundStyle(Color.Gray.gray500)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(
                    RoundedRectangle(cornerRadius: Radius.s)
                        .stroke(Color.Gray.gray500, lineWidth: LineWidth.m)
                )
        }
        .buttonStyle(.plain)
    }

    var confirmButton: some View {
        Button(action: onConfirm) {
            Text("완료")
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

// MARK: - Convenience Init for String Options

public extension TXSelectionModalView where Option == String {
    /// String 옵션을 위한 간편 생성자입니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// TXSelectionModalView(
    ///     title: "언어 설정",
    ///     subtitle: "이미 앱 내에 저장된 언어는 변경되지 않아요",
    ///     options: ["한국어", "English", "日本語"],
    ///     selectedOption: $selectedLanguage,
    ///     onCancel: { },
    ///     onConfirm: { }
    /// )
    /// ```
    init(
        title: String,
        subtitle: String? = nil,
        options: [String],
        selectedOption: Binding<String>,
        onCancel: @escaping () -> Void,
        onConfirm: @escaping () -> Void
    ) {
        self.init(
            title: title,
            subtitle: subtitle,
            options: options,
            optionLabel: { $0 },
            selectedOption: selectedOption,
            onCancel: onCancel,
            onConfirm: onConfirm
        )
    }
}

// MARK: - Preview

#Preview {
    struct PreviewWrapper: View {
        @State private var selected = "한국어"

        var body: some View {
            TXSelectionModalView(
                title: "언어 설정",
                subtitle: "이미 앱 내에 저장된 언어는 변경되지 않아요",
                options: ["한국어", "English", "日本語"],
                selectedOption: $selected,
                onCancel: { },
                onConfirm: { }
            )
        }
    }

    return PreviewWrapper()
}
