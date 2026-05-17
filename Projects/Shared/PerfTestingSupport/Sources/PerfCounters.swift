import Foundation
import SwiftUI

/// Process-wide counters for Pass 3 direct instrumentation. Counters are only
/// mutated when `UITestMode.isEnabled` is true, so production builds pay only
/// for a single boolean check on each call. Counter values are surfaced to
/// UITests via accessibility markers (see `perfCounterMarkers(slug:keys:)`).
public enum PerfCounters {
    private static let lock = NSLock()
    private static var values: [String: Int] = [:]

    /// Increments the named counter. No-op in production.
    public static func increment(_ key: String) {
        guard UITestMode.isEnabled else { return }
        lock.lock()
        values[key, default: 0] += 1
        lock.unlock()
    }

    /// Reads the current value of a counter. Always returns 0 in production.
    public static func value(for key: String) -> Int {
        guard UITestMode.isEnabled else { return 0 }
        lock.lock()
        defer { lock.unlock() }
        return values[key, default: 0]
    }
}

/// Proxy counter for SwiftUI view rebuild frequency. Increments on every
/// `init` because SwiftUI re-instantiates the View struct whenever its parent
/// body re-evaluates. This is a **proxy**, not an exact body-eval count —
/// SwiftUI may skip body closure evaluation for structurally identical views
/// even when they are re-initialized. Treat the counter as an upper bound /
/// invalidation-frequency signal, not an exact body invocation count.
public struct PerfRebuildProxyPing: View {
    public init(_ key: String) {
        PerfCounters.increment(key)
    }

    public var body: some View {
        Color.clear.frame(width: 0, height: 0)
    }
}
