//
//  ShakeDetectingUIKit.swift
//  CoreLogging
//
//  Created by Jiyong
//

#if DEBUG
import Foundation
import UIKit

/// Shake 제스처를 감지하는 Notification 이름
extension Notification.Name {
    static let deviceDidShake = Notification.Name("deviceDidShake")
}

/// UIWindow에서 직접 shake를 감지합니다.
/// First responder와 관계없이 모든 shake 이벤트를 캐치합니다.
extension UIWindow {
    override open func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)

        if motion == .motionShake {
            NotificationCenter.default.post(name: .deviceDidShake, object: nil)
        }
    }
}

/// Deprecated: UIWindow extension이 shake를 자동으로 감지합니다.
@available(*, deprecated, message: "UIWindow extension handles shake detection automatically")
class ShakeDetectingHostingController: UIViewController {
    override var canBecomeFirstResponder: Bool {
        true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resignFirstResponder()
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)

        if motion == .motionShake {
            NotificationCenter.default.post(name: .deviceDidShake, object: nil)
        }
    }
}

/// Deprecated: Use ShakeDetectorModifier directly
@available(*, deprecated, message: "Use ShakeDetectorModifier directly")
class ShakeDetectingViewController: UIViewController {
    override var canBecomeFirstResponder: Bool {
        true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resignFirstResponder()
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)

        if motion == .motionShake {
            NotificationCenter.default.post(name: .deviceDidShake, object: nil)
        }
    }
}
#endif
