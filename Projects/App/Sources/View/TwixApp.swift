import ComposableArchitecture
import GoogleSignIn
import KakaoSDKAuth
import KakaoSDKCommon
import SwiftUI

#if DEBUG
import CoreLogging
#endif

@main
struct TwixApp: App {
    init() {
        configureKakaoSDK()
    }

    var body: some Scene {
        WindowGroup {
            AppRootView(
                store: Store(
                    initialState: AppRootReducer.State()
                ) {
                    AppRootReducer()
                }
            )
            .onOpenURL { url in
                if AuthApi.isKakaoTalkLoginUrl(url) {
                    _ = AuthController.handleOpenUrl(url: url)
                }
                GIDSignIn.sharedInstance.handle(url)
            }
        }
    }
}

private extension TwixApp {
    func configureKakaoSDK() {
        guard let kakaoAppKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_APP_KEY") as? String else {
            fatalError("KAKAO_APP_KEY not found in Info.plist")
        }
        KakaoSDK.initSDK(appKey: kakaoAppKey)
    }
}
