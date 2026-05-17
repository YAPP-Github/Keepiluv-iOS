import SharedPerfTestingSupportUITests
import XCTest

/// Pass 3 action-latency scenarios for FeatureHomeExample.
///
/// PRIMARY (`testActionLatency_toastShowDismiss`): toggles `HomeReducer.State.toast`
/// between `nil` and `.warning(message:)` via PERF-only buttons in `HomeView`.
/// Production HomeView does not observe `toast` (the field is consumed by
/// `MainTabView` in the production app shell), so a `PerfToastPresentationHarness`
/// modifier conditionally adds the observation only when `UITestMode.isEnabled`.
/// This is a list-content-independent presentation-only state change, so the
/// Pass 3 Phase E Commit 3 read-set split should narrow this observation into
/// a presentation sub-view rather than the parent HomeView body.
///
/// SECONDARY (`testActionLatency_calendarMonthToggle`): toggles `calendarDate`
/// via `.setCalendarDate`. Real production state change observed by the
/// calendar sub-view but ALSO triggers `calendarWeeks`/`items` cascade. Useful
/// for measuring read-set split effect on cascading invalidation.
///
/// Reported metrics (`Clock Monotonic Time`) are **bundle latency** for
/// `repetitions: 5` iterations of show+dismiss (or next+prev). Per-action
/// latency is `bundle / 5 / 2` (each repetition is two state changes).
final class HomeExampleActionLatencyTests: XCTestCase {
    func testActionLatency_toastShowDismiss() {
        let app = XCUIApplication.launchForPerf(seed: "default")
        waitForFeatureReady("home", timeout: 30)

        let showButton = app.descendants(matching: .any)["feature.home.perf.toast-show"]
        let dismissButton = app.descendants(matching: .any)["feature.home.perf.toast-dismiss"]
        XCTAssertTrue(showButton.waitForExistence(timeout: 5), "PERF toast-show button missing")
        XCTAssertTrue(dismissButton.exists, "PERF toast-dismiss button missing")
        awaitPerfMarker(slug: "home", key: "toast", value: "hidden", timeout: 5)

        measureActionLatency(repetitions: 5) {
            showButton.tap()
            awaitPerfMarker(slug: "home", key: "toast", value: "visible")
            dismissButton.tap()
            awaitPerfMarker(slug: "home", key: "toast", value: "hidden")
        }

        let rebuildProxy = readPerfCounter(slug: "home", key: "home.view.rebuild.proxy")
        XCTAssertGreaterThan(rebuildProxy, 0, "home.view.rebuild.proxy counter never incremented")
        print("[perf-counters] home.view.rebuild.proxy=\(rebuildProxy)")
    }

    func testActionLatency_calendarMonthToggle() {
        let app = XCUIApplication.launchForPerf(seed: "default")
        waitForFeatureReady("home", timeout: 30)

        let nextButton = app.descendants(matching: .any)["feature.home.perf.calendar-next"]
        let prevButton = app.descendants(matching: .any)["feature.home.perf.calendar-prev"]
        XCTAssertTrue(nextButton.waitForExistence(timeout: 5), "PERF calendar-next button missing")
        XCTAssertTrue(prevButton.exists, "PERF calendar-prev button missing")

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

        let rebuildProxy = readPerfCounter(slug: "home", key: "home.view.rebuild.proxy")
        XCTAssertGreaterThan(rebuildProxy, 0, "home.view.rebuild.proxy counter never incremented")
        print("[perf-counters] home.view.rebuild.proxy=\(rebuildProxy)")
    }
}
