//
//  AppVersionProvider.swift
//  SharedUtil
//
//  Created by Jiyong on 02/05/26.
//

import Foundation

/// 앱 버전 정보를 제공하는 유틸리티입니다.
public enum AppVersionProvider {
    /// 현재 앱 버전을 반환합니다. (예: "1.0.0")
    public static var currentVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
    }

    /// 현재 앱 빌드 번호를 반환합니다. (예: "1")
    public static var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0"
    }

    /// 버전과 빌드 번호를 함께 반환합니다. (예: "1.0.0 (1)")
    public static var fullVersion: String {
        "\(currentVersion) (\(buildNumber))"
    }

    /// App Store에서 최신 버전을 가져옵니다.
    ///
    /// - Parameter bundleId: 앱의 Bundle ID (nil이면 현재 앱의 Bundle ID 사용)
    /// - Returns: 스토어의 최신 버전 문자열, 없으면 nil
    public static func fetchStoreVersion(bundleId: String? = nil) async -> String? {
        let identifier = bundleId ?? Bundle.main.bundleIdentifier ?? ""
        guard !identifier.isEmpty else { return nil }

        let urlString = "https://itunes.apple.com/lookup?bundleId=\(identifier)&country=kr"
        guard let url = URL(string: urlString) else { return nil }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(AppStoreLookupResponse.self, from: data)
            return response.results.first?.version
        } catch {
            return nil
        }
    }

    /// 업데이트가 필요한지 확인합니다.
    ///
    /// - Parameter storeVersion: 스토어 버전
    /// - Returns: 업데이트가 필요하면 true
    public static func needsUpdate(storeVersion: String) -> Bool {
        currentVersion.compare(storeVersion, options: .numeric) == .orderedAscending
    }
}

// MARK: - App Store API Response

private struct AppStoreLookupResponse: Decodable {
    let resultCount: Int
    let results: [AppStoreResult]
}

private struct AppStoreResult: Decodable {
    let version: String
}
