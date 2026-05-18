import SharedPerfTestingSupportUITests
import XCTest

/// Pass 3 **rendering driver** UITest for FeatureHomeExample.
///
/// This is the first authoritative rendering scenario for the home feed.
/// It is NOT a benchmark. The XCTest pass/fail status and any timing the
/// XCTest harness happens to print are not the rendering metric — they only
/// indicate whether the deterministic UI script completed.
///
/// ## Intended use
///
/// 1. Start an Instruments / xctrace recording (Time Profiler or SwiftUI
///    template) on a real device against the `FeatureHomeExample` bundle id.
/// 2. Launch this test against the same device. The test launches with
///    `-UITEST` + `-UITEST_RENDERING_SCENARIO` + `-UITEST_SEED home-heavy`,
///    so the PERF probe harness (`perfActionHarness`,
///    `PerfRebuildProxyPing`, calendar marker, `PerfToastPresentationHarness`,
///    counter markers) is NOT activated and the production layout is
///    preserved.
/// 3. Stop the trace when the test reports completion.
/// 4. Compare before/after traces in Instruments — that comparison is the
///    authoritative rendering metric.
///
/// ## Determinism
///
/// - Single seed (`home-heavy` → 200 cells, fixed per-index content) so the
///   visible item set is reproducible across runs.
/// - Fixed number of `swipeUp()` calls so the recording window covers the
///   same logical workload each run.
/// - `-UITEST_DISABLE_ANIMATIONS` reduces frame-to-frame variance from
///   animation timing.
/// - No XCTest `measure(metrics:)`. The driver runs once per launch.
///
/// ## Guardrails
///
/// - Asserts that the probe harness identifiers are absent, to catch the
///   bug where someone accidentally activates `-UITEST_PROBE_SCENARIO` and
///   pollutes a rendering trace with the 44pt layout shift.
final class HomeExampleFeedScrollRenderingTests: XCTestCase {

    /// Drives the home-heavy feed scroll. Not a benchmark — use Instruments
    /// for the rendering metric. See class doc.
    func testRendering_homeHeavyFeedScroll() {
        let app = XCUIApplication.launchForPerf(
            seed: "home-heavy",
            scenario: .rendering
        )
        waitForFeatureReady("home", timeout: 30)

        // Guardrail: rendering scenarios must NOT activate the PERF probe
        // harness, otherwise the 44pt layout shift would change scroll
        // geometry / LazyVStack materialization range and contaminate the
        // trace. If these identifiers exist, someone passed
        // `-UITEST_PROBE_SCENARIO` by accident.
        let probeToastShow = app.descendants(matching: .any)["feature.home.perf.toast-show"]
        XCTAssertFalse(
            probeToastShow.exists,
            "PERF probe harness is active under a rendering scenario launch. The trace this driver produces would be polluted by the 44pt layout shift. Re-check launchForPerf(scenario:) arguments."
        )

        let feed = app.descendants(matching: .any)["feature.home.feed"]
        XCTAssertTrue(feed.waitForExistence(timeout: 10), "feature.home.feed not found")

        // Fixed-count scroll drive. The deterministic workload, not a
        // benchmark. Instruments recording is the authoritative metric.
        for _ in 0..<20 {
            feed.swipeUp()
        }
    }
}
