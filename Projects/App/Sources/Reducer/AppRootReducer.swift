//
//  AppRootReducer.swift
//  Twix
//
//  Created by 정지훈 on 1/4/26.
//

import ComposableArchitecture
import DomainAuthInterface
import Feature
import Foundation

@Reducer
struct AppRootReducer {
    @Dependency(\.authClient)
    var authClient
    
    @Dependency(\.tokenManager)
    var tokenManager

    private let authReducer: AuthReducer
    private let mainTabReducer: MainTabReducer

    @ObservableState
    struct State: Equatable {
        var path: PathState = .auth(AuthReducer.State())
        var isCheckingAuth: Bool = true

        public init() { }
    }

    @ObservableState
    @CasePathable
    public enum PathState: Equatable {
        case auth(AuthReducer.State)
        case mainTab(MainTabReducer.State)

        var auth: AuthReducer.State? {
            if case .auth(let state) = self {
                return state
            }
            return nil
        }

        var mainTab: MainTabReducer.State? {
            if case .mainTab(let state) = self {
                return state
            }
            return nil
        }
    }

    enum Action {
        case onAppear
        case checkAuthResult(Result<Token?, Error>)
        case path(PathAction)
    }

    @CasePathable
    public enum PathAction {
        case auth(AuthReducer.Action)
        case mainTab(MainTabReducer.Action)
    }

    init() {
        self.authReducer = AuthReducer()
        self.mainTabReducer = MainTabReducer()
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.path, action: \.path) {
            Scope(state: \.auth, action: \.auth) {
                authReducer
            }
            Scope(state: \.mainTab, action: \.mainTab) {
                mainTabReducer
            }
        }

        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
//                    고의로 실패하여 재 로그인을 원하는 경우 아래 주석 사용
//                    키체인에 토큰이 저장되는 형식이므로, 로그아웃 기능 구현 전까지 임시 조치
//                    await send(.checkAuthResult(.failure(NSError())))
                    do {
                        let token = try await tokenManager.loadTokenFromStorage {
                            try await authClient.loadToken()
                        }
                        await send(.checkAuthResult(.success(token)))
                    } catch {
                        await send(.checkAuthResult(.failure(error)))
                    }
                }

            case .checkAuthResult(.success(let token)):
                state.isCheckingAuth = false
                if token != nil {
                    state.path = .mainTab(MainTabReducer.State())
                } else {
                    state.path = .auth(AuthReducer.State())
                }
                return .none

            case .checkAuthResult(.failure):
                state.isCheckingAuth = false
                state.path = .auth(AuthReducer.State())
                return .none

            case .path(.auth(.delegate(.loginSucceeded))):
                state.path = .mainTab(MainTabReducer.State())
                return .none

            case .path:
                return .none
            }
        }
    }
}
