//
//  SettingsReducer.swift
//  FeatureSettingsInterface
//
//  Created by Jiyong on 02/05/26.
//

import ComposableArchitecture
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
        // Navigation
        public var routes: [SettingsRoute] = []

        // Profile
        public var nickname: String
        public var originalNickname: String
        public var isEditing: Bool
        public var isLoading: Bool

        // Language Modal
        public var isLanguageModalPresented: Bool
        public var selectedLanguage: String

        // Account
        public var coupleCode: String
        public var modal: TXModalType?

        // Info
        public var appVersion: String
        public var storeVersion: String

        // Notification Settings
        public var isPokePushEnabled: Bool
        public var isMarketingPushEnabled: Bool
        public var isNightMarketingPushEnabled: Bool

        public static let minLength = 2
        public static let maxLength = 8
        public static let languageOptions = ["한국어", "English", "日本語"]

        /// 상태를 생성합니다.
        ///
        /// ## 사용 예시
        /// ```swift
        /// let state = SettingsReducer.State(nickname: "김민정", coupleCode: "JF2342S")
        /// ```
        public init(
            nickname: String = "",
            isEditing: Bool = false,
            selectedLanguage: String = "한국어",
            coupleCode: String = "",
            appVersion: String = "",
            storeVersion: String = "",
            isPokePushEnabled: Bool = true,
            isMarketingPushEnabled: Bool = false,
            isNightMarketingPushEnabled: Bool = false
        ) {
            self.nickname = nickname
            self.originalNickname = nickname
            self.isEditing = isEditing
            self.isLoading = false
            self.isLanguageModalPresented = false
            self.selectedLanguage = selectedLanguage
            self.coupleCode = coupleCode
            self.appVersion = appVersion
            self.storeVersion = storeVersion
            self.isPokePushEnabled = isPokePushEnabled
            self.isMarketingPushEnabled = isMarketingPushEnabled
            self.isNightMarketingPushEnabled = isNightMarketingPushEnabled
        }
    }

    /// 설정 화면에서 발생하는 액션입니다.
    public enum Action: BindableAction {
        case binding(BindingAction<State>)

        // MARK: - User Action
        case backButtonTapped
        case editButtonTapped
        case clearButtonTapped
        case languageSettingTapped
        case accountTapped
        case infoTapped
        case inquiryTapped
        case notificationSettingTapped
        case privacyPolicyTapped

        // MARK: - Lifecycle
        case onAppear

        // MARK: - Internal
        case nicknameEditingEnded
        case languageConfirmed
        case storeVersionResponse(String?)

        // MARK: - Navigation
        case popRoute

        // MARK: - Account Actions
        case logoutTapped
        case disconnectCoupleTapped
        case withdrawTapped
        case modalConfirmTapped

        // MARK: - API Response
        case updateNicknameResponse(Result<Void, Error>)
        case fetchMyProfileResponse(Result<String, Error>)
        case fetchCoupleCodeResponse(Result<String, Error>)
        case logoutResponse(Result<Void, Error>)
        case withdrawResponse(Result<Void, Error>)

        // MARK: - Delegate
        case delegate(Delegate)

        public enum Delegate: Equatable {
            case navigateBack
            case logoutCompleted
            case withdrawCompleted
        }
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
    /// 닉네임 길이가 유효한지 여부 (2-8자)
    public var isNicknameLengthValid: Bool {
        nickname.count >= Self.minLength && nickname.count <= Self.maxLength
    }

    /// 닉네임이 변경되었는지 여부
    public var isNicknameChanged: Bool {
        nickname != originalNickname
    }

    /// 닉네임에 비속어가 포함되어 있는지 여부
    public var containsProfanity: Bool {
        ProfanityFilter.containsProfanity(nickname)
    }

    /// 닉네임이 유효한지 여부 (길이 + 비속어 체크)
    public var isNicknameValid: Bool {
        isNicknameLengthValid && !containsProfanity
    }
}
