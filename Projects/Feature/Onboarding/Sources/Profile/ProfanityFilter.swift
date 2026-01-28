//
//  ProfanityFilter.swift
//  FeatureOnboarding
//
//  Created by Claude on 01/28/26.
//

import Foundation

/// 비속어 필터링을 위한 유틸리티입니다.
enum ProfanityFilter {
    /// 비속어 목록 (lazy 로드)
    private static let profanityList: [String] = {
        guard let url = Bundle.module.url(forResource: "profanity_list", withExtension: "txt"),
              let content = try? String(contentsOf: url, encoding: .utf8) else {
            return []
        }
        return content.components(separatedBy: .newlines).filter { !$0.isEmpty }
    }()

    /// 입력 문자열에 비속어가 포함되어 있는지 확인합니다.
    static func containsProfanity(_ text: String) -> Bool {
        let lowercased = text.lowercased()
        return profanityList.contains { lowercased.contains($0.lowercased()) }
    }
}
