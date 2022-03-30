import Coordinator
import Dependency
import Kit
import Keychain
import MyTeamwork
import OAuth2
import os
import UIKit

final class AppDelegate: UIResponder, UIApplicationDelegate
{
    @Dependency private var oauth2Configuration: OAuth2Configuration?
    private var isConfigurationInjected: Bool {
        oauth2Configuration != nil
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard isConfigurationInjected else {
            fatalError("Misconfigured application. Check the logs for additional details.")
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        if connectingSceneSession.role == UISceneSession.Role.windowApplication {
            let config = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
            config.delegateClass = SceneDelegate.self
            return config
        }
        fatalError("Unhandled scene role \(connectingSceneSession.role)")
    }
}

private final class SceneDelegate: UIResponder, UIWindowSceneDelegate
{
    @Dependency private var oauth2Store: OAuth2Store
    @Dependency private var rootCoordinatorFactory: RootCoordinatorFactory
    @Dependency private var oauth2Client: OAuth2Client

    private var coordinator: Coordinating?
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions)
    {

        turnOffNavigationBarTransparency()
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        self.coordinator = rootCoordinatorFactory.create(window: window)
        coordinator?.start()
        window.makeKeyAndVisible()
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>)
    {
        SafeTask {
            do {
                let callbackContext = URLContexts.first(where: { context in
                    oauth2Client.isCallbackURL(url: context.url)
                })?.url
                if let callbackURL = callbackContext {
                    let accessTokenResponse = try await oauth2Client.handleCallback(url: callbackURL)
                    try oauth2Store.write(accessTokenResponse)
                }
            } catch {
                Logger(subsystem: "dev.jano", category: "app")
                    .error("🚨 \(String(describing: error))")
            }
            self.coordinator = window.flatMap { rootCoordinatorFactory.create(window: $0) }
            coordinator?.start()
        }
    }

    private func turnOffNavigationBarTransparency() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
    }
}
