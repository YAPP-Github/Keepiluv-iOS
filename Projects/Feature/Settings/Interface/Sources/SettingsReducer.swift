//
//  SettingsReducer.swift
//  FeatureSettingsInterface
//
//  Created by Jiyong on 02/05/26.
//

import ComposableArchitecture
import DomainNotificationInterface
import Foundation
import SharedDesignSystem
import SharedUtil

/// 설정 화면의 상태와 액션을 정의하는 리듀서입니다.
///
/// ## 사용 예시
/// ```swift
/// let reducer = SettingsReducer(
///     reducer: Reduce { state, action in
///         // 실제 로직
///         return .none
///     }
/// )
/// ```
@Reducer
public struct SettingsReducer {
    private let reducer: Reduce<State, Action>

    /// 설정 화면의 상태입니다.
    @ObservableState
    public struct State: Equatable {

        // MARK: - Nested Structs

        /// 도메인 데이터
        public struct Data: Equatable {
            public var nickname: String
            public var originalNickname: String
            public var coupleCode: String
            public var appVersion: String
            public var storeVersion: String

            public init(
                nickname: String = "",
                coupleCode: String = "",
                appVersion: String = "",
                storeVersion: String = ""
            ) {
                self.nickname = nickname
                self.originalNickname = nickname
                self.coupleCode = coupleCode
                self.appVersion = appVersion
                self.storeVersion = storeVersion
            }
        }

        /// UI 상태
        public struct UIState: Equatable {
            public var isEditing: Bool = false
            public var isLoading: Bool = false
            public var selectedLanguage: TXLanguage = .korean
            public var isPokePushEnabled: Bool = true
            public var isMarketingPushEnabled: Bool = false
            public var isNightMarketingPushEnabled: Bool = false
            public var isNotificationSettingsLoading: Bool = false
            public var isSystemNotificationEnabled: Bool = true

            public init() {}
        }

        /// 프레젠테이션
        public struct Presentation: Equatable {
            public var modal: TXModalStyle?
            public var modalPurpose: ModalPurpose?
            public var toast: TXToastType?

            public init() {}
        }

        // MARK: - State Instances

        public var data: Data
        public var ui: UIState
        public var presentation: Presentation

        // MARK: - Constants

        public static let minLength = 2
        public static let maxLength = 8
        // 로컬라이징 지원 이후 활성화 예정
        public static let languageOptions = TXLanguage.allCases
        // 로컬라이징 지원 이후 English, 日本語 추가 예정

        public enum ModalPurpose: Equatable {
            case disconnectCouple
            case withdraw
        }

        // TODO: - 임시 임치
        public enum TXLanguage: Equatable, CaseIterable {
            case korean

            public var title: String {
                switch self {
                case .korean: "한국어"
                }
            }
        }

        /// 상태를 생성합니다.
        ///
        /// ## 사용 예시
        /// ```swift
        /// let state = SettingsReducer.State(nickname: "김민정", coupleCode: "JF2342S")
        /// ```
        public init(
            nickname: String = "",
            isEditing: Bool = false,
            selectedLanguage: TXLanguage = .korean,
            coupleCode: String = "",
            appVersion: String = "",
            storeVersion: String = "",
            isPokePushEnabled: Bool = true,
            isMarketingPushEnabled: Bool = false,
            isNightMarketingPushEnabled: Bool = false
        ) {
            self.data = Data(
                nickname: nickname,
                coupleCode: coupleCode,
                appVersion: appVersion,
                storeVersion: storeVersion
            )
            self.ui = UIState()
            self.ui.isEditing = isEditing
            self.ui.selectedLanguage = selectedLanguage
            self.ui.isPokePushEnabled = isPokePushEnabled
            self.ui.isMarketingPushEnabled = isMarketingPushEnabled
            self.ui.isNightMarketingPushEnabled = isNightMarketingPushEnabled
            self.presentation = Presentation()
        }
    }

    /// 설정 화면에서 발생하는 액션입니다.
    public enum Action: BindableAction {
        case binding(BindingAction<State>)

        // MARK: - View (사용자 이벤트)
        public enum View: Equatable {
            case backButtonTapped
            case subViewBackButtonTapped
            case editButtonTapped
            case clearButtonTapped
            case languageSettingTapped
            case accountTapped
            case infoTapped
            case inquiryTapped
            case notificationSettingTapped
            case privacyPolicyTapped
            case logoutTapped
            case disconnectCoupleTapped
            case withdrawTapped
            case modalConfirmTapped
            case pokePushToggled(Bool)
            case marketingPushToggled(Bool)
            case nightPushToggled(Bool)
            case enableNotificationBannerTapped
        }

        // MARK: - Internal (Reducer 내부 Effect)
        public enum Internal: Equatable {
            case onAppear
            case notificationSettingsOnAppear
            case nicknameEditingEnded
            case languageConfirmed(Int)
            case storeVersionResponse(String?)
        }

        // MARK: - Response (비동기 응답 - Error 포함으로 Equatable 미적용)
        public enum Response {
            case updateNicknameResponse(Result<Void, Error>)
            case fetchMyProfileResponse(Result<String, Error>)
            case fetchCoupleCodeResponse(Result<String, Error>)
            case logoutResponse(Result<Void, Error>)
            case withdrawResponse(Result<Void, Error>)
            case fetchNotificationSettingsResponse(Result<NotificationSettings, Error>)
            case updateNotificationSettingResponse(Result<NotificationSettings, Error>)
            case checkSystemNotificationResponse(Bool)
        }

        // MARK: - Presentation (프레젠테이션 관련)
        public enum Presentation: Equatable {
            case showToast(TXToastType)
        }

        // MARK: - Delegate (부모에게 알림)
        public enum Delegate: Equatable {
            case navigateBack
            case navigateBackFromSubView
            case navigateToAccount
            case navigateToInfo
            case navigateToNotificationSettings
            case navigateToWebView(url: URL, title: String)
            case logoutCompleted
            case withdrawCompleted
            case sessionExpired
        }

        case view(View)
        case `internal`(Internal)
        case response(Response)
        case presentation(Presentation)
        case delegate(Delegate)
    }

    /// 외부에서 주입된 Reduce로 리듀서를 구성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let reducer = SettingsReducer(
    ///     reducer: Reduce { state, action in
    ///         // 실제 로직
    ///         return .none
    ///     }
    /// )
    /// ```
    public init(reducer: Reduce<State, Action>) {
        self.reducer = reducer
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()
        reducer
    }
}

// MARK: - Computed Properties

extension SettingsReducer.State {
    public var isNicknameLengthValid: Bool {
        data.nickname.count >= Self.minLength && data.nickname.count <= Self.maxLength
    }

    public var isNicknameChanged: Bool {
        data.nickname != data.originalNickname
    }

    public var containsProfanity: Bool {
        ProfanityFilter.containsProfanity(data.nickname)
    }

    public var isNicknameValid: Bool {
        isNicknameLengthValid && !containsProfanity
    }
}
