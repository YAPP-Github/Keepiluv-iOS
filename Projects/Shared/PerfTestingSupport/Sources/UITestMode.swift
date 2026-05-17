import ComposableArchitecture
import SwiftUI

/// Launch argument contract shared by Example apps and perf UITests.
public enum UITestMode {
    private static let arguments = ProcessInfo.processInfo.arguments

    /// Cached so production code on the increment fast-path of `PerfCounters`
    /// pays a single `let` read instead of scanning `ProcessInfo.arguments`
    /// every call.
    public static let isEnabled: Bool = arguments.contains("-UITEST")

    public static var seedName: String {
        value(after: "-UITEST_SEED") ?? "default"
    }

    public static var disablesAnimations: Bool {
        arguments.contains("-UITEST_DISABLE_ANIMATIONS")
    }

    public static var waitsForReady: Bool {
        arguments.contains("-UITEST_WAIT_READY")
    }

    public static func configureApplication() {
        guard isEnabled, disablesAnimations else { return }
        UIView.setAnimationsEnabled(false)
    }

    public static func dependencyValues(
        _ update: @escaping (inout DependencyValues) -> Void
    ) -> (inout DependencyValues) -> Void {
        { values in
            guard isEnabled else { return }
            update(&values)
        }
    }

    private static func value(after key: String) -> String? {
        guard let index = arguments.firstIndex(of: key) else { return nil }
        let valueIndex = arguments.index(after: index)
        guard arguments.indices.contains(valueIndex) else { return nil }
        return arguments[valueIndex]
    }
}
