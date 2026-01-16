//
//  AuthView.swift
//  FeatureAuth
//
//  Created by Jiyong
//

// swiftlint:disable no_magic_numbers

import ComposableArchitecture
import FeatureAuthInterface
import SwiftUI

public struct AuthView: View {
    let store: StoreOf<AuthReducer>

    public init(store: StoreOf<AuthReducer>) {
        self.store = store
    }

    public var body: some View {
        VStack(spacing: 24) {
            Spacer()
            titleSection
            Spacer()
            loginButtonsSection
            loadingView
            Spacer(minLength: 40)
        }
        .alert(
            "로그인 실패",
            isPresented: Binding(
                get: { store.errorMessage != nil },
                set: { _ in store.send(.dismissError) }
            )
        ) {
            Button("확인") {
                store.send(.dismissError)
            }
        } message: {
            Text(store.errorMessage ?? "")
        }
    }
}

// MARK: - View Components

private extension AuthView {
    var titleSection: some View {
        VStack(spacing: 12) {
            Text("Twix")
                .font(.system(size: 40, weight: .bold))

            Text("함께하는 기록의 시작")
                .font(.headline)
                .foregroundColor(.secondary)
        }
    }

    var loginButtonsSection: some View {
        VStack(spacing: 12) {
            appleLoginButton
            kakaoLoginButton
            googleLoginButton
        }
        .padding(.horizontal, 24)
    }

    var appleLoginButton: some View {
        Button {
            store.send(.appleLoginButtonTapped)
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "apple.logo")
                    .font(.headline)
                Text("Apple로 로그인")
                    .font(.headline)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(Color.black)
            .cornerRadius(12)
        }
        .disabled(store.isLoading)
    }

    var kakaoLoginButton: some View {
        Button {
            store.send(.kakaoLoginButtonTapped)
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "message.fill")
                    .font(.headline)
                Text("Kakao로 로그인")
                    .font(.headline)
            }
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(Color(red: 0.996, green: 0.898, blue: 0))
            .cornerRadius(12)
        }
        .disabled(store.isLoading)
    }

    var googleLoginButton: some View {
        Button {
            store.send(.googleLoginButtonTapped)
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "g.circle.fill")
                    .font(.headline)
                Text("Google로 로그인")
                    .font(.headline)
            }
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
        .disabled(store.isLoading)
    }

    var loadingView: some View {
        Group {
            if store.isLoading {
                ProgressView()
                    .padding(.top, 8)
            }
        }
    }
}

// swiftlint:enable no_magic_numbers

#Preview {
    AuthView(
        store: Store(
            initialState: AuthReducer.State(),
            reducer: { AuthReducer() }
        )
    )
}
