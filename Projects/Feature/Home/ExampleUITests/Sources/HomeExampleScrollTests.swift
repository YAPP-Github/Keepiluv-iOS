import SharedPerfTestingSupportUITests
import XCTest

final class HomeExampleScrollTests: XCTestCase {
    func testScrollFiftyCells() {
        let app = XCUIApplication.launchForPerf(seed: "scroll-50")
        waitForFeatureReady("home")

        let feed = app.descendants(matching: .any)["feature.home.feed"]
        XCTAssertTrue(feed.waitForExistence(timeout: 5), "feature.home.feed not found")

        for _ in 0..<5 {
            feed.swipeUp()
        }
    }
}
