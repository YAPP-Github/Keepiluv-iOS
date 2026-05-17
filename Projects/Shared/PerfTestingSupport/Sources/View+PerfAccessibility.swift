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
}
