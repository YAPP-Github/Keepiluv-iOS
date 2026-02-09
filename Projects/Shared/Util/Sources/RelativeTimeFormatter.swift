//
//  RelativeTimeFormatter.swift
//  SharedUtil
//
//  Created by Codex on 02/09/26.
//

import Foundation

/// 업로드 시간 문자열을 상대 시간 텍스트로 변환합니다.
///
/// ISO8601 형식(`2026-02-09T11:41:48Z`)을 입력으로 받아 다음 규칙으로 표시합니다.
///
/// - 00초~10분: "방금 전"
/// - 11분~59분: "N분 전"
/// - 60분~23시간 59분: "N시간 전"
/// - 24시간 이후: "N일 전"
///
/// ## 사용 예시
/// ```swift
/// let formatter = RelativeTimeFormatter()
/// let text = formatter.displayText(from: "2026-02-09T11:41:48Z")
/// ```
public struct RelativeTimeFormatter {
    public init() { }
    
    public func displayText(from raw: String?) -> String {
        guard let raw, !raw.isEmpty else { return "" }
        
        let isoWithFractional = ISO8601DateFormatter()
        isoWithFractional.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime]
        
        let date =
            isoWithFractional.date(from: raw) ??
            iso.date(from: raw)
        
        guard let date else { return raw }
        
        let now = Date()
        let seconds = max(0, now.timeIntervalSince(date))
        let minutes = Int(seconds / 60)
        if minutes <= 10 {
            return "방금 전"
        }
        if minutes < 60 {
            return "\(minutes)분 전"
        }
        let hours = minutes / 60
        if hours < 24 {
            return "\(hours)시간 전"
        }
        let days = hours / 24
        return "\(days)일 전"
    }
}
