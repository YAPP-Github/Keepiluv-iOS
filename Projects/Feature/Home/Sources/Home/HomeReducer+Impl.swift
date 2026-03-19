//
//  HomeReducer+Impl.swift
//  FeatureHome
//
//  Created by 정지훈 on 1/26/26.
//

import Foundation
import SwiftUI

import ComposableArchitecture
import CoreCaptureSessionInterface
import DomainGoalInterface
import DomainNotificationInterface
import DomainPhotoLogInterface
import FeatureHomeInterface
import FeatureProofPhotoInterface
import SharedDesignSystem
import SharedUtil

// MARK: - Poke Cooldown Manager

private enum PokeCooldownManager {
    private static let userDefaultsKey = "pokeCooldownTimestamps"
    private static let cooldownInterval: TimeInterval = 3 * 60 * 60 // 3시간

    /// 찌르기 쿨다운 남은 시간을 반환합니다.
    /// - Parameter goalId: 목표 ID
    /// - Returns: 남은 시간(초). 쿨다운이 끝났으면 nil
    static func remainingCooldown(goalId: Int64) -> TimeInterval? {
        guard let timestamps = UserDefaults.standard.dictionary(forKey: userDefaultsKey) as? [String: TimeInterval],
              let lastPokeTime = timestamps[String(goalId)] else {
            return nil
        }
        let elapsed = Date().timeIntervalSince1970 - lastPokeTime
        let remaining = cooldownInterval - elapsed
        return remaining > 0 ? remaining : nil
    }

    /// 남은 시간을 포맷팅합니다.
    /// - Parameter seconds: 남은 시간(초)
    /// - Returns: "2시간 20분", "1시간", "28분" 형태의 문자열
    static func formatRemainingTime(_ seconds: TimeInterval) -> String {
        let totalMinutes = Int(ceil(seconds / 60))
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60

        if hours > 0 && minutes > 0 {
            return "\(hours)시간 \(minutes)분"
        } else if hours > 0 {
            return "\(hours)시간"
        } else {
            return "\(max(1, minutes))분"
        }
    }

    /// 찌르기 시간을 기록합니다.
    /// - Parameter goalId: 목표 ID
    static func recordPoke(goalId: Int64) {
        var timestamps = UserDefaults.standard.dictionary(forKey: userDefaultsKey) as? [String: TimeInterval] ?? [:]
        timestamps[String(goalId)] = Date().timeIntervalSince1970
        UserDefaults.standard.set(timestamps, forKey: userDefaultsKey)
    }
}

// MARK: - HomeReducer Implementation

extension HomeReducer {
    /// 실제 로직을 포함한 HomeReducer를 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let reducer = HomeReducer()
    /// ```
    public init(
        proofPhotoReducer: ProofPhotoReducer
    ) {
        @Dependency(\.goalClient) var goalClient
        @Dependency(\.captureSessionClient) var captureSessionClient
        @Dependency(\.photoLogClient) var photoLogClient
        @Dependency(\.notificationClient) var notificationClient
        let reducer = Reduce<State, Action> { state, action in
            switch action {
            case let .view(viewAction):
                return reduceView(
                    state: &state,
                    action: viewAction,
                    goalClient: goalClient,
                    captureSessionClient: captureSessionClient,
                    photoLogClient: photoLogClient
                )

            case let .internal(internalAction):
                return reduceInternal(
                    state: &state,
                    action: internalAction,
                    goalClient: goalClient,
                    notificationClient: notificationClient
                )

            case let .response(responseAction):
                return reduceResponse(
                    state: &state,
                    action: responseAction
                )

            case let .presentation(presentationAction):
                return reducePresentation(
                    state: &state,
                    action: presentationAction
                )

            case .delegate:
                return .none

            case .proofPhoto(.delegate(.closeProofPhoto)):
                state.presentation.isProofPhotoPresented = false
                return .none

            case let .proofPhoto(.delegate(.completedUploadPhoto(myPhotoLog, _))):
                state.presentation.isProofPhotoPresented = false
                guard let goalId = state.proofPhoto?.goalId else { return .none }
                guard let index = state.data.cards.firstIndex(where: { $0.id == goalId }) else { return .none }
                let imageURL = myPhotoLog.imageUrl.flatMap(URL.init(string:))
                state.data.cards[index].myCard = .init(
                    photologId: myPhotoLog.photologId,
                    imageURL: imageURL,
                    isSelected: true,
                    emoji: state.data.cards[index].myCard.emoji
                )
                state.data.goalsCache[TXCalendarUtil.apiDateString(for: state.data.calendarDate)] = state.data.cards
                return .none

            case .proofPhoto:
                return .none

            case .binding:
                return .none
            }
        }

        self.init(
            reducer: reducer,
            proofPhotoReducer: proofPhotoReducer
        )
    }
}

// MARK: - View Actions

private func reduceView(
    state: inout HomeReducer.State,
    action: HomeReducer.Action.View,
    goalClient: GoalClient,
    captureSessionClient: CaptureSessionClient,
    photoLogClient: PhotoLogClient
) -> Effect<HomeReducer.Action> {
    switch action {
    case .onAppear:
        if state.data.calendarDate.day == nil {
            let now = state.ui.nowDate
            let date = TXCalendarDate(
                year: now.year,
                month: now.month,
                day: now.day
            )
            return .send(.internal(.setCalendarDate(date)))
        }
        state.ui.isLoading = true
        return .send(.internal(.fetchGoals))

    case let .calendarDateSelected(item):
        guard let components = item.dateComponents,
              let year = components.year,
              let month = components.month,
              let day = components.day else {
            return .none
        }
        return .send(.internal(.setCalendarDate(TXCalendarDate(year: year, month: month, day: day))))

    case let .weekCalendarSwipe(swipe):
        switch swipe {
        case .next:
            guard let nextWeekDate = TXCalendarUtil.dateByAddingWeek(
                from: state.data.calendarDate,
                by: 1
            ) else {
                return .none
            }
            return .send(.internal(.setCalendarDate(nextWeekDate)))

        case .previous:
            guard let previousWeekDate = TXCalendarUtil.dateByAddingWeek(
                from: state.data.calendarDate,
                by: -1
            ) else {
                return .none
            }
            return .send(.internal(.setCalendarDate(previousWeekDate)))
        }

    case let .navigationBarAction(action):
        switch action {
        case .refreshTapped:
            let now = state.ui.nowDate
            let date = TXCalendarDate(
                year: now.year,
                month: now.month,
                day: now.day
            )
            if date == state.data.calendarDate {
                state.ui.isLoading = true
                return .send(.internal(.fetchGoals))
            }
            return .send(.internal(.setCalendarDate(date)))

        case .subTitleTapped:
            return .send(.internal(.setCalendarSheetPresented(true)))

        case .alertTapped:
            return .send(.delegate(.goToNotification))

        case .settingTapped:
            return .send(.delegate(.goToSettings))

        case .backTapped,
             .rightTapped,
             .closeTapped:
            return .none
        }

    case .monthCalendarConfirmTapped:
        state.presentation.isCalendarSheetPresented = false
        return .send(.internal(.setCalendarDate(state.data.calendarSheetDate)))

    case let .goalCheckButtonTapped(id, isChecked):
        if isChecked {
            guard let card = state.data.cards.first(where: { $0.id == id }),
                  let photologId = card.myCard.photologId else {
                return .none
            }
            state.data.pendingDeleteGoalID = id
            state.data.pendingDeletePhotologID = photologId
            state.presentation.modal = .info(.uncheckGoal)
            return .none
        } else {
            let now = state.ui.nowDate
            let today = TXCalendarDate(
                year: now.year,
                month: now.month,
                day: now.day
            )
            if state.data.calendarDate > today {
                return .send(.presentation(.showToast(.warning(message: "미래의 인증샷은 지금 올릴 수 없어요!"))))
            } else {
                return .run { send in
                    let isAuthorized = await captureSessionClient.fetchIsAuthorized()
                    await send(.internal(.authorizationCompleted(id: id, isAuthorized: isAuthorized)))
                }
            }
        }

    case .modalConfirmTapped:
        guard let pendingGoalID = state.data.pendingDeleteGoalID,
              let pendingPhotologID = state.data.pendingDeletePhotologID else {
            return .none
        }
        state.data.pendingDeleteGoalID = nil
        state.data.pendingDeletePhotologID = nil
        return .run { send in
            do {
                try await photoLogClient.deletePhotoLog(pendingPhotologID)
                await send(.response(.deletePhotoLogResult(.success(pendingGoalID))))
            } catch {
                await send(.response(.deletePhotoLogResult(.failure(HomeReducer.HomeError.unknown))))
            }
        }

    case let .yourCardTapped(card):
        if !card.yourCard.isSelected {
            if let remaining = PokeCooldownManager.remainingCooldown(goalId: card.id) {
                let timeText = PokeCooldownManager.formatRemainingTime(remaining)
                return .send(.presentation(.showToast(.warning(message: "\(timeText) 뒤에 다시 찌를 수 있어요"))))
            }
            return .run { send in
                do {
                    try await goalClient.pokePartner(card.id)
                    PokeCooldownManager.recordPoke(goalId: card.id)
                    await send(.response(.pokePartnerResult(.success(card.id))))
                } catch {
                    await send(.response(.pokePartnerResult(.failure(HomeReducer.HomeError.unknown))))
                }
            }
        } else {
            let verificationDate = TXCalendarUtil.apiDateString(for: state.data.calendarDate)
            return .send(.delegate(.goToGoalDetail(id: card.id, owner: .you, verificationDate: verificationDate)))
        }

    case let .myCardTapped(card):
        let verificationDate = TXCalendarUtil.apiDateString(for: state.data.calendarDate)
        return .send(.delegate(.goToGoalDetail(id: card.id, owner: .mySelf, verificationDate: verificationDate)))

    case let .headerTapped(card):
        return .send(.delegate(.goToStatsDetail(id: card.id)))

    case .floatingButtonTapped:
        state.presentation.isAddGoalPresented = true
        return .none

    case .editButtonTapped:
        return .send(.delegate(.goToEditGoalList(date: state.data.calendarDate)))

    case let .addGoalButtonTapped(category):
        state.presentation.isAddGoalPresented = false
        return .send(.delegate(.goToMakeGoal(category)))

    case .cameraPermissionAlertDismissed:
        state.presentation.isCameraPermissionAlertPresented = false
        return .none

    case .proofPhotoDismissed:
        state.proofPhoto = nil
        return .none
    }
}

// MARK: - Internal Actions

private func reduceInternal(
    state: inout HomeReducer.State,
    action: HomeReducer.Action.Internal,
    goalClient: GoalClient,
    notificationClient: NotificationClient
) -> Effect<HomeReducer.Action> {
    switch action {
    case .fetchGoals:
        let date = state.data.calendarDate
        let cacheKey = TXCalendarUtil.apiDateString(for: date)
        if let cachedItems = state.data.goalsCache[cacheKey] {
            state.data.cards = cachedItems
            state.ui.isLoading = false
        } else {
            state.ui.isLoading = true
        }
        return .run { send in
            if let hasUnread = try? await notificationClient.fetchUnread() {
                await send(.response(.fetchUnreadResult(hasUnread)))
            }

            do {
                let goals = try await goalClient.fetchGoals(cacheKey)
                let items: [GoalCardItem] = goals.map { goal in
                    let myImageURL = goal.myVerification?.imageURL.flatMap(URL.init(string:))
                    let yourImageURL = goal.yourVerification?.imageURL.flatMap(URL.init(string:))
                    return GoalCardItem(
                        id: goal.id,
                        goalName: goal.title,
                        goalEmoji: GoalIcon(from: goal.goalIcon).image,
                        myCard: .init(
                            photologId: goal.myVerification?.photologId,
                            imageURL: myImageURL,
                            isSelected: goal.myVerification?.isCompleted ?? false,
                            emoji: goal.myVerification?.emoji.flatMap { ReactionEmoji(from: $0)?.image }
                        ),
                        yourCard: .init(
                            photologId: goal.yourVerification?.photologId,
                            imageURL: yourImageURL,
                            isSelected: goal.yourVerification?.isCompleted ?? false,
                            emoji: goal.yourVerification?.emoji.flatMap { ReactionEmoji(from: $0)?.image }
                        )
                    )
                }
                await send(.response(.fetchGoalsResult(.success(items), date: date)))
            } catch {
                await send(.response(.fetchGoalsResult(.failure(HomeReducer.HomeError.unknown), date: date)))
            }
        }

    case let .setCalendarDate(date):
        guard date != state.data.calendarDate else { return .none }

        let today = TXCalendarDate()
        let calendar = Calendar(identifier: .gregorian)

        state.data.calendarDate = date
        state.ui.calendarMonthTitle = "\(date.month)월 \(date.year)"
        state.data.calendarWeeks = TXCalendarDataGenerator.generateWeekData(for: date)

        if let selectedDate = date.date,
           let todayDate = today.date {
            let isThisWeek = calendar.isDate(
                selectedDate,
                equalTo: todayDate,
                toGranularity: .weekOfYear
            )
            state.ui.isRefreshHidden = isThisWeek
        }

        state.ui.isLoading = true
        return .send(.internal(.fetchGoals))

    case let .setCalendarSheetPresented(isPresented):
        state.presentation.isCalendarSheetPresented = isPresented
        if isPresented {
            state.data.calendarSheetDate = state.data.calendarDate
        }
        return .none

    case let .authorizationCompleted(id, isAuthorized):
        if !isAuthorized {
            state.presentation.isCameraPermissionAlertPresented = true
            return .none
        }
        state.proofPhoto = .init(
            goalId: id,
            verificationDate: TXCalendarUtil.apiDateString(for: state.data.calendarDate)
        )
        state.presentation.isProofPhotoPresented = true
        return .none
    }
}

// MARK: - Response Actions

private func reduceResponse(
    state: inout HomeReducer.State,
    action: HomeReducer.Action.Response
) -> Effect<HomeReducer.Action> {
    switch action {
    case let .fetchGoalsResult(.success(items), date):
        let cacheKey = TXCalendarUtil.apiDateString(for: date)
        state.data.goalsCache[cacheKey] = items

        if date != state.data.calendarDate {
            return .none
        }
        state.ui.isLoading = false
        if state.data.cards != items {
            state.data.cards = items
        }
        return .none

    case .fetchGoalsResult(.failure, _):
        state.ui.isLoading = false
        return .send(.presentation(.showToast(.warning(message: "목표 조회에 실패했어요"))))

    case let .deletePhotoLogResult(.success(goalId)):
        guard let index = state.data.cards.firstIndex(where: { $0.id == goalId }) else {
            return .none
        }
        state.data.cards[index].myCard = .init(
            photologId: nil,
            imageURL: nil,
            isSelected: false,
            emoji: state.data.cards[index].myCard.emoji
        )
        state.data.goalsCache[TXCalendarUtil.apiDateString(for: state.data.calendarDate)] = state.data.cards
        return .send(.presentation(.showToast(.delete(message: "인증이 해제되었어요"))))

    case .deletePhotoLogResult(.failure):
        return .send(.presentation(.showToast(.warning(message: "해제에 실패했어요"))))

    case let .fetchUnreadResult(hasUnread):
        state.ui.hasUnreadNotification = hasUnread
        return .none

    case .pokePartnerResult(.success):
        return .send(.presentation(.showToast(.poke(message: "상대방을 찔렀어요!"))))

    case .pokePartnerResult(.failure):
        return .send(.presentation(.showToast(.warning(message: "찌르기에 실패했어요"))))
    }
}

// MARK: - Presentation Actions

private func reducePresentation(
    state: inout HomeReducer.State,
    action: HomeReducer.Action.Presentation
) -> Effect<HomeReducer.Action> {
    switch action {
    case let .showToast(toast):
        state.presentation.toast = toast
        return .none
    }
}
