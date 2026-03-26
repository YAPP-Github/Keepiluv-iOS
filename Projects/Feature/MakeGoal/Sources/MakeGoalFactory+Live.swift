import SwiftUI

import ComposableArchitecture
import FeatureMakeGoalInterface

extension MakeGoalFactory: @retroactive DependencyKey {
    public static var liveValue: MakeGoalFactory = Self { store in
        AnyView(MakeGoalView(store: store))
    }
}
