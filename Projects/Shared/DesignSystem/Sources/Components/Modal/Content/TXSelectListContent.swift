//
//  TXSelectListContent.swift
//  SharedDesignSystem
//
//  Created by Codex on 4/7/26.
//

import SwiftUI

struct TXSelectListContent: View {
    private let title: String
    private let subtitle: String?
    private let options: [String]
    @Binding private var selectedIndex: Int

    init(
        title: String,
        subtitle: String?,
        options: [String],
        selectedIndex: Binding<Int>
    ) {
        self.title = title
        self.subtitle = subtitle
        self.options = options
        self._selectedIndex = selectedIndex
    }

    var body: some View {
        VStack(spacing: Constants.contentSpacing) {
            titleSection
            optionsList
        }
        .padding(.top, Constants.topPadding)
        .padding(.horizontal, Constants.horizontalPadding)
    }
}

// MARK: - SubViews

private extension TXSelectListContent {
    var titleSection: some View {
        VStack(spacing: Constants.titleSpacing) {
            Text(title)
                .typography(Constants.titleTypography)
                .foregroundStyle(Constants.textColor)

            if let subtitle {
                Text(subtitle)
                    .typography(Constants.subtitleTypography)
                    .foregroundStyle(Constants.textColor)
            }
        }
        .multilineTextAlignment(.center)
    }

    var optionsList: some View {
        VStack(alignment: .leading, spacing: Constants.optionSpacing) {
            ForEach(Array(options.enumerated()), id: \.offset) { index, option in
                optionRow(index: index, option: option)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    func optionRow(index: Int, option: String) -> some View {
        Button {
            selectedIndex = index
        } label: {
            HStack(spacing: Constants.optionContentSpacing) {
                checkIcon(isSelected: selectedIndex == index)

                Text(option)
                    .typography(Constants.optionTypography)
                    .foregroundStyle(Constants.textColor)
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
        .frame(width: Constants.checkIconSize, height: Constants.checkIconSize)
    }
}

// MARK: - Constants

private extension TXSelectListContent {
    enum Constants {
        static let contentSpacing = Spacing.spacing9
        static let titleSpacing = Spacing.spacing5
        static let optionSpacing = Spacing.spacing8
        static let optionContentSpacing = Spacing.spacing5
        static let topPadding = Spacing.spacing8
        static let horizontalPadding = Spacing.spacing8
        static let checkIconSize: CGFloat = 28
        static let titleTypography = TypographyToken.t1_18eb
        static let subtitleTypography = TypographyToken.b2_14r
        static let optionTypography = TypographyToken.b2_14r
        static let textColor = Color.Gray.gray500
    }
}
