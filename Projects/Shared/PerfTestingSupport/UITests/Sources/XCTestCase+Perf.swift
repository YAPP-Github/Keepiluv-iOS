import XCTest

public func waitForFeatureReady(
    _ slug: String,
    timeout: TimeInterval = 10,
    file: StaticString = #filePath,
    line: UInt = #line
) {
    let app = XCUIApplication()
    let ready = app.descendants(matching: .any)["feature.\(slug).ready"]
    XCTAssertTrue(
        ready.waitForExistence(timeout: timeout),
        "Timed out waiting for feature.\(slug).ready",
        file: file,
        line: line
    )
}

/// Waits for a `perfStateMarker(slug:key:value:)` to exist. Each unique value
/// produces a unique accessibility identifier, so `waitForExistence` can be
/// used to detect that SwiftUI has reflected a specific state mutation.
public func awaitPerfMarker(
    slug: String,
    key: String,
    value: String,
    timeout: TimeInterval = 5,
    file: StaticString = #filePath,
    line: UInt = #line
) {
    let app = XCUIApplication()
    let identifier = "feature.\(slug).marker.\(key).\(value)"
    let marker = app.descendants(matching: .any)[identifier]
    XCTAssertTrue(
        marker.waitForExistence(timeout: timeout),
        "Timed out waiting for marker \(identifier)",
        file: file,
        line: line
    )
}

/// Reads the latest value of a `PerfCounters` counter via its accessibility
/// marker (see `perfCounterMarkers(slug:keys:)`). Returns `-1` if no marker is
/// present (e.g. counter never written, or view body has not yet re-evaluated
/// after the increment). Trigger a body re-render via a state-change marker
/// before reading to ensure the marker reflects the latest counter value.
public func readPerfCounter(slug: String, key: String) -> Int {
    let app = XCUIApplication()
    let prefix = "feature.\(slug).counter.\(key)."
    let query = app.descendants(matching: .any).matching(
        NSPredicate(format: "identifier BEGINSWITH %@", prefix)
    )
    for index in 0..<query.count {
        let identifier = query.element(boundBy: index).identifier
        if let suffix = identifier.components(separatedBy: prefix).last,
           let value = Int(suffix) {
            return value
        }
    }
    return -1
}

public var defaultPerfMetrics: [XCTMetric] {
    [
        XCTClockMetric(),
        XCTMemoryMetric(),
        XCTCPUMetric()
    ]
}

/// Metrics tuned for same-screen state-change action latency measurements.
/// Excludes memory delta (dominated by SwiftUI internals and not the action path).
public var actionLatencyMetrics: [XCTMetric] {
    [
        XCTClockMetric(),
        XCTCPUMetric()
    ]
}

public extension XCTestCase {
    /// Wraps `measure(metrics:)` and repeats the supplied closure `repetitions`
    /// times per iteration. Use for action-latency scenarios where each action
    /// alone is too short to amortize XCTest measurement overhead.
    func measureActionLatency(
        metrics: [XCTMetric] = actionLatencyMetrics,
        repetitions: Int = 5,
        _ body: () -> Void
    ) {
        measure(metrics: metrics) {
            for _ in 0..<repetitions {
                body()
            }
        }
    }
}
