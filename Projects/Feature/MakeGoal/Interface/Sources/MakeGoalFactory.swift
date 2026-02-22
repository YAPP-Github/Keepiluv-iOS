import SwiftUI

import ComposableArchitecture

public struct MakeGoalFactory: Sendable {
    public var makeView: @MainActor (StoreOf<MakeGoalReducer>) -> AnyView

    public init(makeView: @escaping @MainActor (StoreOf<MakeGoalReducer>) -> AnyView) {
        self.makeView = makeView
    }
}

extension MakeGoalFactory: TestDependencyKey {
    public static var testValue: MakeGoalFactory = Self(
        makeView: { _ in
            assertionFailure("MakeGoalFactory.makeView is unimplemented")
            return AnyView(EmptyView())
        }
    )
}

public extension DependencyValues {
    var makeGoalFactory: MakeGoalFactory {
        get { self[MakeGoalFactory.self] }
        set { self[MakeGoalFactory.self] = newValue }
    }
}
