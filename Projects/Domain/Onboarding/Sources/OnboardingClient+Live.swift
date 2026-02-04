//
//  OnboardingClient+Live.swift
//  DomainOnboarding
//

import ComposableArchitecture
import CoreNetworkInterface
import DomainOnboardingInterface
import Foundation

extension OnboardingClient: @retroactive DependencyKey {
    public static let liveValue = OnboardingClient(
        fetchInviteCode: {
            @Dependency(\.networkClient) var networkClient

            do {
                let response: InviteCodeResponse = try await networkClient.request(
                    endpoint: OnboardingEndpoint.fetchInviteCode
                )
                return response.inviteCode
            } catch let error as NetworkError {
                throw OnboardingErrorMapper.map(error, context: .general)
            } catch {
                throw OnboardingError.unknown
            }
        },
        connectCouple: { inviteCode in
            @Dependency(\.networkClient) var networkClient

            do {
                let _: EmptyResponse = try await networkClient.request(
                    endpoint: OnboardingEndpoint.connectCouple(inviteCode: inviteCode)
                )
            } catch let error as NetworkError {
                throw OnboardingErrorMapper.map(error, context: .connectCouple)
            } catch {
                throw OnboardingError.unknown
            }
        },
        registerProfile: { nickname in
            @Dependency(\.networkClient) var networkClient

            do {
                let _: EmptyResponse = try await networkClient.request(
                    endpoint: OnboardingEndpoint.registerProfile(nickname: nickname)
                )
            } catch let error as NetworkError {
                throw OnboardingErrorMapper.map(error, context: .general)
            } catch {
                throw OnboardingError.unknown
            }
        },
        setAnniversary: { date in
            @Dependency(\.networkClient) var networkClient

            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 9 * 60 * 60)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: date)

            do {
                let _: EmptyResponse = try await networkClient.request(
                    endpoint: OnboardingEndpoint.setAnniversary(date: dateString)
                )
            } catch let error as NetworkError {
                throw OnboardingErrorMapper.map(error, context: .general)
            } catch {
                throw OnboardingError.unknown
            }
        },
        fetchStatus: {
            @Dependency(\.networkClient) var networkClient

            do {
                let response: OnboardingStatusResponse = try await networkClient.request(
                    endpoint: OnboardingEndpoint.fetchStatus
                )
                return response.status
            } catch let error as NetworkError {
                throw OnboardingErrorMapper.map(error, context: .general)
            } catch {
                throw OnboardingError.unknown
            }
        }
    )
}

// MARK: - Empty Response

struct EmptyResponse: Decodable {}

// MARK: - Error Mapping

private enum OnboardingErrorMapper {
    enum Context {
        case general
        case connectCouple
    }

    static func map(
        _ error: NetworkError,
        context: Context
    ) -> Error {
        switch error {
        case .authorizationError:
            return error

        case .notFoundError where context == .connectCouple:
            return OnboardingError.inviteCodeNotFound

        case .badRequestError where context == .connectCouple:
            return OnboardingError.invalidInviteCode

        case .serverError, .decodingError:
            return OnboardingError.serverError

        case .encodingError:
            return OnboardingError.unknown

        case .invalidURLError,
             .invalidResponseError,
             .unknownError,
             .badRequestError,
             .notFoundError:
            return OnboardingError.networkError
        }
    }
}
