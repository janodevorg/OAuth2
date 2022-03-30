import Foundation
import os

private enum Key: String, CaseIterable, Hashable {
    case key
    case secret
    case callback
    case authorizationRequestURL
    case authorizationCodeGrantRequestURL
    case api
}

/**
 Client registration data provided by the service provider during registration.

 To register your application go to:
   - Teamwork: https://{yourTeamworkInstance}.com/developer
   - Tumblr: https://www.tumblr.com/oauth/apps
*/
public struct OAuth2Configuration
{
    public struct Registration
    {
        /// A value used by the client to identify itself to the Service Provider.
        public let key: String

        /// A secret used by the client to establish ownership of the client key.
        public let secret: String

        /// URL to return to the client application.
        public let callback: URL
    }

    public struct Endpoints
    {
        // OAuth2 authorization request URL for this provider
        public let authorizationRequestURL: URL

        // OAuth2 authorization code grant request URL for this provider
        public let authorizationCodeGrantRequestURL: URL

        // Base endpoint for API requests
        public let apiURL: URL
    }

    public let registration: Registration
    public let endpoints: Endpoints

    /// Create instance from plist filename.
    public static func createFrom(filename: String, bundle: Bundle = Bundle.main) throws -> OAuth2Configuration {
        guard let url = bundle.url(forResource: filename, withExtension: nil) else {
            throw OAuth2Error.invalidRegistration(reason: "Missing file \(filename) in main Bundle")
        }
        return try createFrom(file: url)
    }

    public static func createFrom(file: URL) throws -> OAuth2Configuration {
        guard let dict = NSDictionary(contentsOf: file) as? [String: String] else {
            throw OAuth2Error.invalidRegistration(reason: "Missing or malformed file at \(file)")
        }
        guard let conf = OAuth2Configuration.create(from: dict) else {
            throw OAuth2Error.invalidRegistration(reason: "Missing keys, values, or wrong values, for file \(file)")
        }
        return conf
    }

    /**
     Create instance from a plist.

     The plist must contain a String/String key-value for the following keys:
     - `clientKey`
     - `clientSecret`
     - `clientCallback`

     - Parameter keyValue: Path to a plist file.
     - Returns: Instance of this object or nil if the file is invalid.
     */
    private static func create(from dict: [String: String]) -> OAuth2Configuration? {
        if let key = dict[Key.key.rawValue],
            let secret = dict[Key.secret.rawValue],

            let callback = dict[Key.callback.rawValue],
            let callbackURL = URL(string: callback),

            let authorizationRequest = dict[Key.authorizationRequestURL.rawValue],
            let authorizationRequestURL = URL(string: authorizationRequest),

            let authorizationCodeGrantRequest = dict[Key.authorizationCodeGrantRequestURL.rawValue],
            let authorizationCodeGrantRequestURL = URL(string: authorizationCodeGrantRequest),

            let api = dict[Key.api.rawValue],
            let apiURL = URL(string: api),

            !key.isEmpty,
            !secret.isEmpty
        {
            return OAuth2Configuration(
                registration: Registration(
                    key: key,
                    secret: secret,
                    callback: callbackURL
                ),
                endpoints: Endpoints(
                    authorizationRequestURL: authorizationRequestURL,
                    authorizationCodeGrantRequestURL: authorizationCodeGrantRequestURL,
                    apiURL: apiURL
                )
            )
        }
        logWarningOnInvalidKeys(dict: dict)
        return nil
    }

    private static func logWarningOnInvalidKeys(dict: [String: String]) {
        let log = Logger(subsystem: "dev.jano", category: "app")
        log.debug("Checking registration file:")
        let urls = Set<Key>(arrayLiteral: .authorizationRequestURL, .authorizationCodeGrantRequestURL, .api)
        for key in Key.allCases {
            var state = "OK"
            if let value = dict[key.rawValue], !value.isEmpty {
                let isURL = urls.contains(key)
                if isURL && URL(string: value) == nil {
                    state = "Invalid URL"
                }
            } else {
                state = "Missing"
            }
            let checkmark = state == "OK" ? "✔": "✘"
            log.debug(" \(checkmark) \(key.rawValue): \(state)")
        }
    }
}
