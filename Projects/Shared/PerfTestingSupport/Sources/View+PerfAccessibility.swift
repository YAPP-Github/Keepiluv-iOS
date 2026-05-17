import SwiftUI

public extension View {
    func perfRoot(_ slug: String) -> some View {
        accessibilityIdentifier("feature.\(slug).root")
    }

    func perfFeed(_ slug: String) -> some View {
        accessibilityIdentifier("feature.\(slug).feed")
    }

    func perfCell(slug: String, stableId: CustomStringConvertible) -> some View {
        accessibilityIdentifier("feature.\(slug).cell.\(stableId)")
    }

    func perfControl(slug: String, element: String) -> some View {
        accessibilityIdentifier("feature.\(slug).\(element)")
    }

    func perfReadyMarker(_ slug: String) -> some View {
        overlay(alignment: .topLeading) {
            Color.clear
                .frame(width: 1, height: 1)
                .accessibilityIdentifier("feature.\(slug).ready")
        }
    }

    /// Exposes a deterministic accessibility marker whose identifier changes when
    /// `value` changes. UITests can `waitForExistence` on a specific value to
    /// detect that SwiftUI has reflected a state mutation.
    func perfStateMarker(slug: String, key: String, value: String) -> some View {
        overlay(alignment: .topLeading) {
            Color.clear
                .frame(width: 1, height: 1)
                .accessibilityIdentifier("feature.\(slug).marker.\(key).\(value)")
        }
    }

    /// Exposes one accessibility marker per `PerfCounters` key. Each marker's
    /// identifier embeds the current counter value, e.g.
    /// `feature.home.counter.home.view.rebuild.proxy.42`. UITests can enumerate
    /// `feature.<slug>.counter.*` after a scenario completes to capture
    /// deltas. The markers are evaluated when the surrounding view body
    /// re-renders; trigger a body re-render via a state-change marker before
    /// reading.
    ///
    /// **Probe-only**. The counter values are sanity signals for the UITest
    /// driver, not authoritative SwiftUI rendering metrics.
    func perfCounterMarkers(slug: String, keys: [String]) -> some View {
        overlay(alignment: .topLeading) {
            VStack(spacing: 0) {
                ForEach(keys, id: \.self) { key in
                    Color.clear
                        .frame(width: 1, height: 1)
                        .accessibilityIdentifier(
                            "feature.\(slug).counter.\(key).\(PerfCounters.value(for: key))"
                        )
                }
            }
        }
    }
}
