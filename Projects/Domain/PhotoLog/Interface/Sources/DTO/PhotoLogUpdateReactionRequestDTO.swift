//
//  PhotoLogUpdateReactionRequestDTO.swift
//  DomainPhotoLogInterface
//
//  Created by Jihun on 2/11/26.
//

import Foundation

/// 인증샷 리액션 추가/수정 요청 DTO입니다.
///
/// ## 사용 예시
/// ```swift
/// let request = PhotoLogUpdateReactionRequestDTO(reaction: "EMOJI_HAPPY")
/// ```
public struct PhotoLogUpdateReactionRequestDTO: Encodable {
    public let reaction: String

    /// 리액션 업데이트 요청 데이터를 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let request = PhotoLogUpdateReactionRequestDTO(reaction: "EMOJI_LOVE")
    /// ```
    public init(reaction: String) {
        self.reaction = reaction
    }
}
