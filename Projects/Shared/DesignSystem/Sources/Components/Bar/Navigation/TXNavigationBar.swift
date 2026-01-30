//
//  TXNavigationBar.swift
//  SharedDesignSystem
//
//  Created by 정지용 on 1/21/26.
//

import SwiftUI

/// 상단 앱바 컴포넌트입니다.
///
/// ## 사용 예시
/// ```swift
/// // mainTitle 스타일
/// TXNavigationBar(style: .mainTitle(title: "스탬프 통계"))
///
/// // home 스타일
/// TXNavigationBar(style: .home(.init(subTitle: "1월 2026", mainTitle: "오늘 우리 목표", isHiddenRefresh: false, isRemainedAlarm: true))) { action in
///     switch action {
///     case .subTitleTapped:
///         // 날짜 선택
///     case .refreshTapped:
///         // 새로고침
///     case .alertTapped:
///         // 알림
///     case .settingTapped:
///         // 설정
///     default:
///         break
///     }
/// }
///
/// // subTitle 스타일
/// TXNavigationBar(style: .subTitle(title: "목표 직접 만들기", rightText: "수정")) { action in
///     switch action {
///     case .backTapped:
///         // 뒤로가기
///     case .rightTapped:
///         // 오른쪽 버튼
///     default:
///         break
///     }
/// }
///
/// // iconOnly 스타일
/// TXNavigationBar(style: .iconOnly(.back)) { action in
///     if action == .backTapped {
///         // 뒤로가기
///     }
/// }
/// ```
public struct TXNavigationBar: View {
    private let style: Style
    private let onAction: ((Action) -> Void)?

    /// NavigationBar를 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// TXNavigationBar(style: .mainTitle(title: "스탬프 통계"))
    /// ```
    public init(
        style: Style,
        onAction: ((Action) -> Void)? = nil
    ) {
        self.style = style
        self.onAction = onAction
    }

    public var body: some View {
        Group {
            switch style {
            case let .mainTitle(title):
                mainTitleContent(title: title)

            case let .home(homeStyle):
                homeContent(homeStyle)

            case let .subTitle(title, rightText):
                subTitleContent(title: title, rightText: rightText)

            case .iconOnly(let iconStyle):
                iconOnlyContent(iconStyle: iconStyle)
            }
        }
        .frame(height: style.height)
        .background(style.backgroundColor)
    }
}

// MARK: - MainTitle Style
private extension TXNavigationBar {
    func mainTitleContent(title: String) -> some View {
        HStack {
            Text(title)
                .typography(style.titleFont)
                .foregroundStyle(style.foregroundColor)

            Spacer()
        }
        .padding(style.horizontalPadding)
    }
}

// MARK: - Home Style
private extension TXNavigationBar {
    func homeContent(_ homeStyle: Style.Home) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                subTitleRow(subTitle: homeStyle.subTitle)
                mainTitleRow(homeStyle)
            }
            .padding(.vertical, 12)

            Spacer()

            homeActionButtons(isRemained: homeStyle.isRemainedAlarm)
        }
        .padding(style.horizontalPadding)
    }

    func subTitleRow(subTitle: String) -> some View {
        Button {
            onAction?(.subTitleTapped)
        } label: {
            HStack(spacing: 0) {
                Text(subTitle)
                    .typography(style.subTitleFont)
                    .foregroundStyle(style.subTitleForegroundColor)

                Image.Icon.Symbol.arrow4
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 20, height: 20)
                    .foregroundStyle(style.subTitleForegroundColor)
            }
        }
        .buttonStyle(.plain)
    }

    func mainTitleRow(_ homeStyle: Style.Home) -> some View {
        HStack(spacing: 4) {
            Text(homeStyle.mainTitle)
                .typography(style.titleFont)
                .foregroundStyle(style.foregroundColor)

            if !homeStyle.isHiddenRefresh {
                Button {
                    onAction?(.refreshTapped)
                } label: {
                    Image.Icon.Symbol.icReturn
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 24, height: 24)
                        .foregroundStyle(style.iconForegroundColor)
                }
                .buttonStyle(.plain)
                .padding(.bottom, 4)
            }
        }
    }

    func homeActionButtons(isRemained: Bool) -> some View {
        HStack(spacing: 0) {
            Button {
                onAction?(.alertTapped)
            } label: {
                alertImage(isRemained: isRemained)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: style.iconSize.width, height: style.iconSize.height)
                    .foregroundStyle(style.iconForegroundColor)
                    .frame(width: style.actionButtonSize.width, height: style.actionButtonSize.height)
            }
            .buttonStyle(.plain)

            Button {
                onAction?(.settingTapped)
            } label: {
                Image.Icon.Symbol.setting
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: style.iconSize.width, height: style.iconSize.height)
                    .foregroundStyle(style.iconForegroundColor)
                    .frame(width: style.actionButtonSize.width, height: style.actionButtonSize.height)
            }
            .buttonStyle(.plain)
        }
    }

    func alertImage(isRemained: Bool) -> Image {
        return isRemained ? Image.Icon.Symbol.alertRemained : Image.Icon.Symbol.alert
    }
}

// MARK: - SubTitle Style
private extension TXNavigationBar {
    func subTitleContent(title: String, rightText: String?) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                TXRectangleButton(
                    config: .blankLeftBack(),
                    action: { onAction?(.backTapped) }
                )

                Spacer()

                Text(title)
                    .typography(style.titleFont)
                    .foregroundStyle(style.foregroundColor)

                Spacer()

                TXRectangleButton(
                    config: .blankRight(text: rightText),
                    action: { onAction?(.rightTapped) }
                )
            }
            .frame(height: 60)
            .insideRectEdgeBorder(
                width: style.borderWidth,
                edges: [.top, .bottom],
                color: style.borderColor
            )
        }
        .padding(.vertical, 20)
    }
}

// MARK: - IconOnly Style
private extension TXNavigationBar {
    func iconOnlyContent(iconStyle: IconStyle) -> some View {
        HStack {
            switch iconStyle {
            case .back:
                Button {
                    onAction?(.backTapped)
                } label: {
                    iconImage(.Icon.Symbol.arrow1LLeft)
                }
                .buttonStyle(.plain)

                Spacer()

            case .close:
                Spacer()

                Button {
                    onAction?(.closeTapped)
                } label: {
                    iconImage(.Icon.Symbol.closeM)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(style.horizontalPadding)
    }

    @ViewBuilder
    func iconImage(_ image: Image) -> some View {
        image
            .resizable()
            .renderingMode(.template)
            .frame(width: style.iconSize.width, height: style.iconSize.height)
            .foregroundStyle(style.foregroundColor)
            .frame(width: style.actionButtonSize.width, height: style.actionButtonSize.height)
    }
}

#Preview("MainTitle") {
    TXNavigationBar(style: .mainTitle(title: "스탬프 통계"))
}

#Preview("Home") {
    TXNavigationBar(
        style: .home(.init(subTitle: "1월 2026", mainTitle: "오늘 우리 목표", isHiddenRefresh: false, isRemainedAlarm: false))
    ) { action in
        print(action)
    }
}

#Preview("SubTitle") {
    TXNavigationBar(style: .subTitle(title: "목표 직접 만들기", rightText: "수정")) { action in
        print(action)
    }
}

#Preview("IconOnly - Back") {
    TXNavigationBar(style: .iconOnly(.back)) { action in
        print(action)
    }
}

#Preview("IconOnly - Close") {
    TXNavigationBar(style: .iconOnly(.close)) { action in
        print(action)
    }
}
