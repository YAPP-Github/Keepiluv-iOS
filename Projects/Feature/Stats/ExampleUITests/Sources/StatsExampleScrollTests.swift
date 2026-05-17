import SharedPerfTestingSupportUITests
import XCTest

final class StatsExampleScrollTests: XCTestCase {
    func testScrollFiftyCells() {
        let app = XCUIApplication.launchForPerf(seed: "scroll-50")
        waitForFeatureReady("stats")

        let feed = app.descendants(matching: .any)["feature.stats.feed"]
        XCTAssertTrue(feed.waitForExistence(timeout: 5), "feature.stats.feed not found")

        for _ in 0..<5 {
            feed.swipeUp()
        }
    }
}
