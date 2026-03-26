import ComposableArchitecture
import CoreNetwork
import CoreNetworkInterface
import CorePushInterface
import CoreStorage
import CoreStorageInterface
import DomainAuth
import DomainAuthInterface
import GoogleSignIn
import KakaoSDKAuth
import KakaoSDKCommon
import SwiftUI

#if CORE_LOGGING_DEBUG && canImport(CoreLoggingDebug)
import CoreLoggingDebug
#endif

@main
struct TwixApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    let store = Store(
        initialState: AppCoordinator.State()
    ) {
        AppCoordinator()
    } withDependencies: {
        $0.networkClient = makeNetworkClient()
        $0.tokenStorage = .liveValue
    }

    init() {
        configureKakaoSDK()
    }

    var body: some Scene {
        WindowGroup {
            AppRootView(store: store)
                .onOpenURL { url in
                    // 유니버셜 링크 처리 (invite code)
                    if let inviteCode = parseInviteCode(from: url) {
                        store.send(.deepLinkReceived(code: inviteCode))
                        return
                    }

                    // 알림 딥링크 처리 (twix://notification/...)
                    if let notificationDeepLink = NotificationDeepLink.parse(from: url) {
                        store.send(.notificationDeepLinkReceived(notificationDeepLink))
                        return
                    }

                    // 카카오 로그인 URL 처리
                    if AuthApi.isKakaoTalkLoginUrl(url) {
                        _ = AuthController.handleOpenUrl(url: url)
                        return
                    }

                    // 구글 로그인 URL 처리
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
}

// MARK: - Network Client Factory

private func makeNetworkClient() -> NetworkClient {
    let authInterceptor = AuthInterceptor(
        tokenManager: TokenManager.shared,
        refreshToken: {
            try await AuthClient.liveValue.refreshToken()
        }
    )

    #if CORE_LOGGING_DEBUG && canImport(CoreLoggingDebug)
    let interceptors: [NetworkInterceptor] = [
        authInterceptor,
        PulseNetworkInterceptor(label: "Network")
    ]
    #else
    let interceptors: [NetworkInterceptor] = [authInterceptor]
    #endif

    return NetworkClient.live(interceptors: interceptors)
}

// MARK: - Private Methods

private extension TwixApp {
    func configureKakaoSDK() {
        guard let kakaoAppKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_APP_KEY") as? String else {
            fatalError("KAKAO_APP_KEY not found in Info.plist")
        }
        KakaoSDK.initSDK(appKey: kakaoAppKey)
    }

    /// 초대 코드 딥링크 파싱
    /// - URL 형식: twix://invite?code=xxx 또는 https://xxx/invite?code=xxx
    func parseInviteCode(from url: URL) -> String? {
        guard url.path == "/invite" || url.path == "invite",
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let code = components.queryItems?.first(where: { $0.name == "code" })?.value,
              !code.isEmpty else {
            return nil
        }
        return code
    }
}
