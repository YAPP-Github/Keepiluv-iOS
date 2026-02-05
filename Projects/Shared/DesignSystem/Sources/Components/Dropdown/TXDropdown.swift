//
//  TXDropdown.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/18/26.
//

import SwiftUI

/// 드롭다운 선택지를 제공하는 컴포넌트입니다.
///
/// ## 사용 예시
/// ```swift
/// TXDropdown(config: .goal) { item in
///     if item == .edit {
///         print("수정하기 선택")
///     }
/// }
/// ```
public struct TXDropdown: View {
    public struct Configuration {
        let items: [TXDropdownItem]
        let width: CGFloat = 88
        let itemHeight: CGFloat = 44
        let leadingPadding: CGFloat = Spacing.spacing7
        let cornerRadius: CGFloat = 8
        let borderWidth: CGFloat = LineWidth.m
        let dividerColor: Color = Color.Gray.gray500
        let borderColor: Color = Color.Gray.gray500
        let textColor: Color = Color.Gray.gray500
        let textTypography: TypographyToken = .b2_14r
        let shadowColor: Color = .black.opacity(0.16)
        let shadowRadius: CGFloat = 20
        let shadowX: CGFloat = 2
        let shadowY: CGFloat = 1

        /// 드롭다운에 표시할 항목 목록으로 설정을 생성합니다.
        ///
        /// ## 사용 예시
        /// ```swift
        /// let config = TXDropdown.Configuration(items: [.edit, .finish, .delete])
        /// ```
        public init(items: [TXDropdownItem]) {
            self.items = items
        }
    }

    private let config: Configuration
    private let onSelect: (TXDropdownItem) -> Void
    
    /// 설정값과 선택 액션으로 드롭다운을 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// TXDropdown(config: .goal) { item in
    ///     print(item)
    /// }
    /// ```
    public init(
        config: Configuration,
        onSelect: @escaping (TXDropdownItem) -> Void
    ) {
        self.config = config
        self.onSelect = onSelect
    }

    public var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(config.items.enumerated()), id: \.offset) { index, item in
                Button {
                    onSelect(item)
                } label: {
                    dropdownItem(item)
                }

                if index != config.items.indices.last {
                    Rectangle()
                        .frame(height: config.borderWidth)
                        .foregroundStyle(config.dividerColor)
                }
            }
        }
        .background(
            Color.Common.white,
            in: RoundedRectangle(cornerRadius: config.cornerRadius)
        )
        .insideBorder(
            config.borderColor,
            shape: RoundedRectangle(cornerRadius: config.cornerRadius),
            lineWidth: config.borderWidth
        )
        .shadow(
            color: config.shadowColor,
            radius: config.shadowRadius,
            x: config.shadowX,
            y: config.shadowY
        )
        .frame(width: config.width)
    }
}

// MARK: - SubViews
private extension TXDropdown {
    func dropdownItem(_ item: TXDropdownItem) -> some View {
        Text(item.title)
            .typography(config.textTypography)
            .foregroundStyle(config.textColor)
            .frame(maxWidth: .infinity, maxHeight: config.itemHeight, alignment: .leading)
            .padding(.leading, config.leadingPadding)
    }
}

#Preview {
    VStack {
        TXDropdown(config: .init(items: TXDropdownItem.allCases), onSelect: { _ in })
    }
}
