//
//  TopTabBar+Content.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/18/26.
//

import Foundation

extension TXTopTabBar.Style {
    /// 탭바에 표시되는 콘텐츠 정의입니다.
    public enum Content {
        case goal

        /// 각 항목의 표시 텍스트입니다.
        var items: [Item] {
            switch self {
            case .goal:
                return [.inProgress, .done]
            }
        }
    }
    
    public enum Item {
        case inProgress
        case done
        
        var title: String {
            switch self {
            case .inProgress:
                return "진행중"
                
            case .done:
                return "종료"
            }
        }
    }
}
