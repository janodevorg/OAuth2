import UIKit

/// A do-nothing app delegate used during unit tests.
final class DummyAppDelegate: NSObject {
    var window: UIWindow?
    override init() {
        super.init()
    }
}
