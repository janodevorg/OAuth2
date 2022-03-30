import Dependency
import OAuth2
import os
import UIKit

/// Controller that prompts the user to reinstall the app.
private final class MissingRegistrationViewController: UIViewController
{
    public override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        view.backgroundColor = .yellow
        let alertController = UIAlertController(
            title: "Fatal error",
            message: "Missing client registration file. \nSee logs for additional details.",
            preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Exit", style: .default, handler: { _ in
            exit(0)
        }))
        present(alertController, animated: true, completion: nil)
    }
}

/// An scene delegate that displays a controller that warns you about a missing configuration file.
private final class MissingRegistrationSceneDelegate: UIResponder, UIWindowSceneDelegate
{
    @Dependency var oauth2Configuration: OAuth2Configuration?
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions)
    {
        if oauth2Configuration != nil {
            Logger(subsystem: "dev.jano", category: "app").error("""
            \n🚨 Configuration is in place but the previous scene delegate is still cached by iOS.
            🚨 You must DELETE the application and reinstall.
            """)
        }

        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        window.rootViewController = MissingRegistrationViewController()
        window.makeKeyAndVisible()
    }
}

/// An app delegate that displays a controller that warns you about a missing configuration file.
final class MissingRegistrationAppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        true
    }

    // Undocumented: This method is not called when relaunching the app. It is only called when the
    // app is first launched after building the app, or when a new window is created (if multiple
    // windows are supported).
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        if connectingSceneSession.role == UISceneSession.Role.windowApplication {
            let config = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
            config.delegateClass = MissingRegistrationSceneDelegate.self
            return config
        }
        fatalError("Unhandled scene role \(connectingSceneSession.role)")
    }
}
