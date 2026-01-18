//
//  TXRoundedRectangleGroupButton+Content.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/18/26.
//

import Foundation

extension TXRoundedRectangleGroupButton.Style {
    /// 모달 액션 그룹에 표시되는 콘텐츠 정의입니다.
    public enum Content {
        case modal

        var items: [Item] {
            switch self {
            case .modal:
                return [.cancel, .delete]
            }
        }
    }

    /// 모달 액션 그룹의 개별 버튼 항목입니다.
    public enum Item: CaseIterable {
        case cancel
        case delete

        var buttonContent: TXRoundedRectangleButton.Style.MediumContent {
            switch self {
            case .cancel:
                return .cancel
            case .delete:
                return .delete
            }
        }

        var colorStyle: ColorStyle {
            switch self {
            case .cancel:
                return .white
            case .delete:
                return .black
            }
        }
    }
}
