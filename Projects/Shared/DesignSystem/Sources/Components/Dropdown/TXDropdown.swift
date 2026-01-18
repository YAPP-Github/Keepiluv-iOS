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
/// TXDropdown { item in
///     print(item)
/// }
/// ```
public struct TXDropdown: View {

    /// 드롭다운에서 제공하는 기본 선택 항목입니다.
    public enum Item: CaseIterable {
        case edit
        case done
        case delete

        public var title: String {
            switch self {
            case .edit: return "수정하기"
            case .done: return "끝내기"
            case .delete: return "삭제하기"
            }
        }
    }

    private let items: [Item] = Item.allCases
    private let onSelect: (Item) -> Void
    
    public init(onSelect: @escaping (Item) -> Void) {
        self.onSelect = onSelect
    }

    public var body: some View {
        dropdown
    }
}

// MARK: - SubViews
private extension TXDropdown {
    var dropdown: some View {
        VStack(spacing: 0) {
            ForEach(items.indices, id: \.self) { index in
                Button {
                    onSelect(items[index])
                } label: {
                    dropdownItem(at: index)
                }

                if index != items.indices.last {
                    Rectangle()
                        .frame(height: LineWidth.m)
                        .foregroundStyle(Color.Gray.gray500)
                }
            }
        }
        .insideBorder(
            Color.Gray.gray500,
            shape: RoundedRectangle(cornerRadius: 8),
            lineWidth: LineWidth.m
        )
        .shadow(color: .black.opacity(0.16), radius: 20, x: 2, y: 1)
        .frame(width: 88)
    }
    
    func dropdownItem(at index: Int) -> some View {
        Text(items[index].title)
            .typography(.b2_14r)
            .foregroundStyle(Color.Gray.gray500)
            .frame(maxWidth: .infinity, maxHeight: 44, alignment: .leading)
            .padding(.leading, Spacing.spacing7)
    }
}

#Preview {
    VStack {
        TXDropdown(onSelect: { _ in })
    }
}
