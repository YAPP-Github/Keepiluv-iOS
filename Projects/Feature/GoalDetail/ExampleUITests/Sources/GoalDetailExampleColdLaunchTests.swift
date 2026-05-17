import SharedPerfTestingSupportUITests
import XCTest

final class GoalDetailExampleColdLaunchTests: XCTestCase {
    func testColdLaunch() {
        measure(metrics: [
            XCTApplicationLaunchMetric(),
            XCTMemoryMetric(),
            XCTCPUMetric()
        ]) {
            _ = XCUIApplication.launchForPerf(seed: "default")
            waitForFeatureReady("goal-detail", timeout: 30)
        }
    }
}
