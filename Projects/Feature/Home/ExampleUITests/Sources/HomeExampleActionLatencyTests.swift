import SharedPerfTestingSupportUITests
import XCTest

/// Pass 3 PRIMARY action-latency scenario for FeatureHomeExample.
///
/// Toggles `HomeReducer.State.calendarDate` between two adjacent months via
/// the production `.setCalendarDate` action (dispatched from a PERF-only
/// hidden button inside `HomeView`). Each toggle exercises the HomeView
/// read-set: calendarMonthTitle / calendarWeeks / isRefreshHidden change and
/// items refetch, which today invalidates the whole HomeView body. After
/// Pass 3 Phase E Commit 3 (read-set split), this scenario should only
/// invalidate the calendar + nav sub-views.
final class HomeExampleActionLatencyTests: XCTestCase {
    func testActionLatency_calendarMonthToggle() {
        let app = XCUIApplication.launchForPerf(seed: "default")
        waitForFeatureReady("home", timeout: 30)

        let nextButton = app.descendants(matching: .any)["feature.home.perf.calendar-next"]
        let prevButton = app.descendants(matching: .any)["feature.home.perf.calendar-prev"]
        XCTAssertTrue(nextButton.waitForExistence(timeout: 5), "PERF calendar-next button missing")
        XCTAssertTrue(prevButton.exists, "PERF calendar-prev button missing")

        // Pin to a known base month so the cycle is deterministic across runs.
        // The PERF buttons mutate from the current calendarDate, so we read the
        // first observed marker to establish the cycle.
        let baseMarker = app.descendants(matching: .any)
            .matching(NSPredicate(format: "identifier BEGINSWITH 'feature.home.marker.calendar-month.'"))
            .firstMatch
        XCTAssertTrue(baseMarker.waitForExistence(timeout: 5), "initial calendar-month marker missing")
        let baseIdentifier = baseMarker.identifier
        let baseValue = baseIdentifier.replacingOccurrences(
            of: "feature.home.marker.calendar-month.",
            with: ""
        )
        let baseParts = baseValue.split(separator: "-").compactMap { Int($0) }
        guard baseParts.count == 2 else {
            XCTFail("unexpected base marker identifier: \(baseIdentifier)")
            return
        }
        let baseYear = baseParts[0]
        let baseMonth = baseParts[1]
        let nextYear = baseMonth == 12 ? baseYear + 1 : baseYear
        let nextMonth = baseMonth == 12 ? 1 : baseMonth + 1
        let nextValue = "\(nextYear)-\(nextMonth)"

        measureActionLatency(repetitions: 5) {
            nextButton.tap()
            awaitPerfMarker(slug: "home", key: "calendar-month", value: nextValue)
            prevButton.tap()
            awaitPerfMarker(slug: "home", key: "calendar-month", value: baseValue)
        }
    }
}
