//
//  CrashlyticsKey.swift
//  CoreCrashlyticsInterface
//

/// Crashlytics custom key 상수 모음입니다.
///
/// `crashlyticsClient.record(error, [CrashlyticsKey.screen: "home"])` 형태로 사용합니다.
public enum CrashlyticsKey {

    // MARK: - 사용자 컨텍스트
    public static let userId = "user_id"
    public static let goalId = "goal_id"

    // MARK: - 화면 컨텍스트
    public static let screen = "screen"

    // MARK: - 네트워크
    public static let networkEndpoint  = "network_endpoint"
    public static let networkMethod    = "network_method"
    public static let httpStatusCode   = "http_status_code"
    public static let networkErrorType = "network_error_type"
    public static let retryCount       = "retry_count"

    // MARK: - 이미지 업로드
    // fetchURL | uploadS3 | createLog
    public static let uploadStep           = "upload_step"
    public static let originalImageBytes   = "original_image_bytes"
    public static let optimizedImageBytes  = "optimized_image_bytes"
    // 이미지 최적화 실패로 원본을 그대로 사용한 경우 "true"
    public static let optimizationFallback = "optimization_fallback"

    // MARK: - 카메라
    public static let captureErrorType = "capture_error_type"

    // MARK: - 인증
    public static let authProvider  = "auth_provider"
    public static let authErrorType = "auth_error_type"

    // MARK: - 키체인
    // save | load | delete
    public static let keychainOperation = "keychain_operation"
    public static let keychainOsStatus  = "keychain_os_status"
}
