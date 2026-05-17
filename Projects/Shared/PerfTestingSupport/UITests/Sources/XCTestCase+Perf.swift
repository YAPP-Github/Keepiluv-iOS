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

public var defaultPerfMetrics: [XCTMetric] {
    [
        XCTClockMetric(),
        XCTMemoryMetric(),
        XCTCPUMetric()
    ]
}
