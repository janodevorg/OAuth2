import os.log
import Report
import SafariServices
import UIKit
import WebKit

/// Login controller for a generic OAuth2 client.
public final class LoginViewController: UIViewController, WKNavigationDelegate
{
    private let log = Logger(subsystem: "dev.jano", category: "oauth2")

    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        return webView
    }()

    private let client: OAuth2Client
    private let onSuccess: (AccessTokenResponse, UIViewController) throws -> Void
    private let useSafari = true

    // MARK: - Initializer

    public init(client: OAuth2Client,
                onSuccess: @escaping (AccessTokenResponse, UIViewController) throws -> Void)
    {
        self.client = client
        self.onSuccess = onSuccess
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController

    public override func loadView() {
        view = webView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        webView.navigationDelegate = self
        startOAuthFlow()
    }

    // MARK: - Start OAuth Flow

    private func startOAuthFlow() {
        restartOnError {
            let request = try client.createAuthorizationRequest(method: .post)
            log.trace("Loading \(Report(request: request, response: nil, data: nil))")
            if let url = request.url, useSafari {
                UIApplication.shared.open(url, options: [:])
            } else {
                webView.load(request)
            }
        }
    }

    // MARK: - WKNavigationDelegate

    public func webView(_ webView: WKWebView,
                        decidePolicyFor navigationAction: WKNavigationAction,
                        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)
    {
        guard let url = navigationAction.request.url else {
            decisionHandler(.cancel)
            return
        }

        guard client.isCallbackURL(url: url) else {
            log.trace("Not a callback URL. Loading \(url.absoluteString)")

            if let scheme = url.scheme,
                !scheme.starts(with: "http") && !scheme.starts(with: "about"),
                !UIApplication.shared.canOpenURL(url)
            {
                log.warning("⚠️ The Info.plist of this app does not contain the custom scheme \(scheme).")
            }

            decisionHandler(.allow)
            return
        }

        log.trace("Handling callback to \(url.absoluteString)")
        handleCallback(url: url)
        decisionHandler(.cancel)
    }

    private func handleCallback(url: URL) {
        SafeTask {
            await restartOnError {
                let accessTokenResponse = try await client.handleCallback(url: url)
                try onSuccess(accessTokenResponse, self)
            }
        }
    }

    // MARK: - Error management

    private func restartOnError(_ op: () throws -> Void) {
        do {
            try op()
        } catch {
            let message = "\(error)"
            log.error("🚨\(message)")
            alertAndRestart()
        }
    }

    private func restartOnError(_ op: () async throws -> Void) async {
        do {
            try await op()
        } catch let responseError as ResponseError {
            let message = "The provider returned an error: \(responseError.description)"
            log.error("🚨\(message)")
            alertAndRestart(message)
        } catch {
            let message = "\(error)"
            log.error("🚨\(message)")
            alertAndRestart()
        }
    }

    private func alertAndRestart(_ message: String? = nil) {
        alert(
            title: "Error",
            message: message ?? "Oh dear! this application encountered an error and can’t continue. Restarting the OAuth flow.",
            onOK: { self.startOAuthFlow() }
        )
    }

    private func alert(title: String, message: String, onOK: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { _ in onOK() })
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
}
