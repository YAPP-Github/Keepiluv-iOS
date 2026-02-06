//
//  ProfanityFilter.swift
//  SharedUtil
//
//  Created by Jiyong on 02/05/26.
//

import Foundation

/// 비속어 필터링을 위한 유틸리티입니다.
///
/// ## 사용 예시
/// ```swift
/// let containsBadWord = ProfanityFilter.containsProfanity("테스트")
/// ```
public enum ProfanityFilter {
    /// 비속어 목록 (lazy 로드)
    private static let profanityList: [String] = {
        guard let url = Bundle.module.url(forResource: "profanity_list", withExtension: "txt"),
              let content = try? String(contentsOf: url, encoding: .utf8) else {
            return []
        }
        return content.components(separatedBy: .newlines).filter { !$0.isEmpty }
    }()

    /// 입력 문자열에 비속어가 포함되어 있는지 확인합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// if ProfanityFilter.containsProfanity(nickname) {
    ///     // 비속어 포함
    /// }
    /// ```
    public static func containsProfanity(_ text: String) -> Bool {
        let lowercased = text.lowercased()
        return profanityList.contains { lowercased.contains($0.lowercased()) }
    }
}
