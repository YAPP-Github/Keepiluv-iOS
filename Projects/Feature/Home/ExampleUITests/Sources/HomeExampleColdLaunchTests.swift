import SharedPerfTestingSupportUITests
import XCTest

final class HomeExampleColdLaunchTests: XCTestCase {
    func testColdLaunch() {
        measure(metrics: [
            XCTApplicationLaunchMetric(),
            XCTMemoryMetric(),
            XCTCPUMetric()
        ]) {
            _ = XCUIApplication.launchForPerf(seed: "default")
            waitForFeatureReady("home", timeout: 30)
        }
    }
}
