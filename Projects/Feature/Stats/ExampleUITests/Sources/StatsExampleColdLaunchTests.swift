import SharedPerfTestingSupportUITests
import XCTest

final class StatsExampleColdLaunchTests: XCTestCase {
    func testColdLaunch() {
        measure(metrics: [
            XCTApplicationLaunchMetric(),
            XCTMemoryMetric(),
            XCTCPUMetric()
        ]) {
            _ = XCUIApplication.launchForPerf(seed: "default")
            waitForFeatureReady("stats", timeout: 30)
        }
    }
}
