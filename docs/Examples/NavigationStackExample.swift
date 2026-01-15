// MARK: - NavigationStack 패턴 완전한 예제
// 이 파일은 학습용 예제입니다. 실제 프로젝트에서는 Feature 모듈로 분리하세요.

import ComposableArchitecture
import SwiftUI

// MARK: - 1️⃣ Home Feature (Root)

@Reducer
struct HomeReducer {
    @ObservableState
    struct State: Equatable {
        var items: [Item] = Item.samples
        var path = StackState<Path.State>()  // ✨ NavigationStack!

        // Stack에 들어갈 수 있는 화면들을 Enum으로 정의
        @CasePathable
        enum Path: Equatable {
            case detail(DetailReducer.State)
            case settings(SettingsReducer.State)
        }
    }

    enum Action {
        case itemTapped(Item)          // 항목 클릭
        case settingsButtonTapped      // 설정 버튼 클릭
        case path(StackActionOf<Path>) // ✨ Stack 액션 (자식 Reducer들의 액션 포함)

        @CasePathable
        enum Path {
            case detail(DetailReducer.Action)
            case settings(SettingsReducer.Action)
        }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .itemTapped(let item):
                // ✨ Push: Stack에 Detail 화면 추가
                state.path.append(.detail(DetailReducer.State(item: item)))
                return .none

            case .settingsButtonTapped:
                // ✨ Push: Stack에 Settings 화면 추가
                state.path.append(.settings(SettingsReducer.State()))
                return .none

            case .path(.element(id: _, action: .detail(.settingsButtonTapped))):
                // Detail 화면에서 설정 버튼 클릭 → Settings 추가
                state.path.append(.settings(SettingsReducer.State()))
                return .none

            case .path(.element(id: _, action: .settings(.delegate(.logoutRequested)))):
                // Settings에서 로그아웃 요청 → 모든 Stack Pop
                state.path.removeAll()
                return .none

            case .path:
                return .none
            }
        }
        // ✨ forEach: Stack의 각 화면을 해당 Reducer와 연결
        .forEach(\.path, action: \.path)
    }
}

struct HomeView: View {
    @Bindable var store: StoreOf<HomeReducer>

    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            List {
                ForEach(store.items) { item in
                    Button {
                        store.send(.itemTapped(item))
                    } label: {
                        HStack {
                            Text(item.name)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Home")
            .toolbar {
                Button {
                    store.send(.settingsButtonTapped)
                } label: {
                    Image(systemName: "gearshape")
                }
            }
        } destination: { store in
            // ✨ Stack의 각 케이스에 따라 View 렌더링
            switch store.case {
            case .detail(let detailStore):
                DetailView(store: detailStore)

            case .settings(let settingsStore):
                SettingsView(store: settingsStore)
            }
        }
    }
}

// MARK: - 2️⃣ Detail Feature (Child)

@Reducer
struct DetailReducer {
    @ObservableState
    struct State: Equatable {
        let item: Item
        var isLoading = false
        var details: String?
    }

    enum Action {
        case onAppear
        case settingsButtonTapped
        case detailsResponse(String)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                return .run { [item = state.item] send in
                    try await Task.sleep(for: .seconds(1))
                    await send(.detailsResponse("Details for \(item.name)"))
                }

            case .settingsButtonTapped:
                // Parent가 처리 (HomeReducer에서 .path 액션으로 받음)
                return .none

            case .detailsResponse(let details):
                state.isLoading = false
                state.details = details
                return .none
            }
        }
    }
}

struct DetailView: View {
    let store: StoreOf<DetailReducer>

    var body: some View {
        VStack(spacing: 20) {
            Text(store.item.name)
                .font(.largeTitle)

            if store.isLoading {
                ProgressView()
            } else if let details = store.details {
                Text(details)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button {
                store.send(.settingsButtonTapped)
            } label: {
                Image(systemName: "gearshape")
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}

// MARK: - 3️⃣ Settings Feature (Child)

@Reducer
struct SettingsReducer {
    @ObservableState
    struct State: Equatable {
        var notificationsEnabled = true
    }

    enum Action {
        case toggleNotifications
        case logoutButtonTapped
        case delegate(Delegate)

        @CasePathable
        enum Delegate {
            case logoutRequested
        }
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .toggleNotifications:
                state.notificationsEnabled.toggle()
                return .none

            case .logoutButtonTapped:
                return .send(.delegate(.logoutRequested))

            case .delegate:
                return .none
            }
        }
    }
}

struct SettingsView: View {
    let store: StoreOf<SettingsReducer>

    var body: some View {
        Form {
            Section {
                Toggle("Notifications", isOn: $store.notificationsEnabled.sending(\.toggleNotifications))
            }

            Section {
                Button("Logout") {
                    store.send(.logoutButtonTapped)
                }
                .foregroundColor(.red)
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Models

struct Item: Equatable, Identifiable {
    let id: UUID
    let name: String

    static let samples = [
        Item(id: UUID(), name: "Item 1"),
        Item(id: UUID(), name: "Item 2"),
        Item(id: UUID(), name: "Item 3")
    ]
}

// MARK: - Preview

#Preview {
    HomeView(
        store: Store(
            initialState: HomeReducer.State()
        ) {
            HomeReducer()
        }
    )
}
