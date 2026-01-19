//
//  TXRoundedRectangleButton+Content.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/17/26.
//

import Foundation

extension TXRoundedRectangleButton.Style {
    /// 작은 버튼에서 사용하는 텍스트 콘텐츠를 정의합니다.
    public enum SmallContent {
        case goToDetail
        case daily
        case weekly
        case monthly
    }
    
    /// 중간 버튼에서 사용하는 텍스트 콘텐츠를 정의합니다.
    public enum MediumContent {
        case cancel
        case goalCompleted
    }
    
    /// 긴 버튼에서 사용하는 텍스트 콘텐츠를 정의합니다.
    public enum LongContent {
        case confirm
    }
}

extension TXRoundedRectangleButton.Style.SmallContent {
    var text: String {
        switch self {
        case .goToDetail:
            return "보러가기"
            
        case .daily:
            return "매일"
            
        case .weekly:
            return "매주"
            
        case .monthly:
            return "매월"
        }
    }
    
    var horizontalPadding: CGFloat {
        return Spacing.spacing6
    }
    
    var verticalPadding: CGFloat {
        return Spacing.spacing3
    }
}

extension TXRoundedRectangleButton.Style.MediumContent {
    var text: String {
        switch self {
        case .cancel:
            return "취소"
            
        case .goalCompleted:
            return "목표 완료"
        }
    }
}

extension TXRoundedRectangleButton.Style.LongContent {
    var text: String {
        switch self {
        case .confirm:
            return "확인"
        }
    }
}
