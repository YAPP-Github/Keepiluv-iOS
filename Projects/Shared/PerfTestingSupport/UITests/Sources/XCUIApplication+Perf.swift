import XCTest

public extension XCUIApplication {
    static func launchForPerf(
        seed: String,
        disableAnimations: Bool = true
    ) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments.append("-UITEST")
        app.launchArguments.append(contentsOf: ["-UITEST_SEED", seed])
        app.launchArguments.append("-UITEST_WAIT_READY")

        if disableAnimations {
            app.launchArguments.append("-UITEST_DISABLE_ANIMATIONS")
        }

        app.launch()
        return app
    }
}
