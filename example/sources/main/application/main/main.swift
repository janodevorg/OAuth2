import os
import UIKit
import OAuth2
import MyTeamwork
import MyTumblr

let app = AppType.tumblr // 👋🏻👋🏻👋🏻 hey! configure your app here
UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, delegateClassName(app: app))

enum AppType
{
    case teamwork
    case tumblr

    var filename: String {
        switch self {
        case .teamwork: return "teamwork.plist"
        case .tumblr: return "tumblr.plist"
        }
    }

    var configuration: OAuth2Configuration? {
        try? OAuth2Configuration.createFrom(filename: filename)
    }
}

private func delegateClassName(app: AppType) -> String
{
    let isRunningTests = NSClassFromString("XCTestCase") != nil
    guard !isRunningTests else {
        return NSStringFromClass(DummyAppDelegate.self)
    }

    guard let configuration = app.configuration else {
        Logger(subsystem: "dev.jano", category: "app").error("""
        \n🚨 Missing registration file '\(app.filename)'. This is a fatal error.
        🚨 Once the file is restored DELETE (not relaunch) the application to erase the cached scene delegate.
        """)
        return NSStringFromClass(MissingRegistrationAppDelegate.self)
    }

    switch app {
    case .tumblr:
        TumblrInjection().injectDependencies(configuration: configuration)
    case .teamwork:
        TWInjection().injectDependencies(configuration: configuration)
    }

    return NSStringFromClass(AppDelegate.self)
}
