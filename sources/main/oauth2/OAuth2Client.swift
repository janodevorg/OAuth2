import Foundation
import os
import APIClient

/// A client that performs OAuth 2 authorization flows.
public class OAuth2Client
{
    private let configuration: OAuth2Configuration

    var ignoreStateCheckOnResponseErrorBecauseMyClientDoesntFollowTheStandard = false

    /// Opaque value to be matched against the callback URL to avoid CSRF attacks.
    /// See [10.12. Cross-Site Request Forgery](https://datatracker.ietf.org/doc/html/rfc6749#section-10.12)
    /// Refreshed on every authorization request.
    private var state: String = ""

    private let log = Logger(subsystem: "dev.jano", category: "oauth2")

    public init(configuration: OAuth2Configuration) {
        self.configuration = configuration
    }

    public func createAuthorizationRequest(method: HTTPMethod = .get) throws -> URLRequest {
        self.state = String.randomString(length: 32)
        return try createTokenRequest(state: self.state, method: method)
    }

    public func isCallbackURL(url: URL) -> Bool
    {
        // check for URL callback
        let callbackString = configuration.registration.callback.absoluteString
        let isCallback = url.absoluteString.hasPrefix(callbackString)
        let isHTTP = url.absoluteString.hasPrefix("http")
        if !isHTTP && !isCallback {
            log.warning("⚠️ Not a callback or HTTP URL. Expected: \(callbackString). Actual: \(url.absoluteString)")
            if let queryItems = url.queryItemDictionary(),
               let response = ResponseError(queryItemDictionary: queryItems) {
                log.error("🚨🚨 Server returned an error: \(response.description)")
                return true
            }
        }
        return isCallback
    }

    public func handleCallback(url: URL) async throws -> AccessTokenResponse
    {
        log.debug("Decoding callback URL: \(url.absoluteString)")

        guard let queryItems = url.queryItemDictionary() else {
            // malformed callback URL
            throw OAuth2Error.invalidCallbackURL(URL: url)
        }

        if let responseError = ResponseError(queryItemDictionary: queryItems) {
            throw responseError
        }

        let authorizationResponse = try decodeTokenResponse(state, url)
        let isSameState = authorizationResponse.state == state || state.isEmpty
        guard isSameState && !ignoreStateCheckOnResponseErrorBecauseMyClientDoesntFollowTheStandard else {
            throw OAuth2Error.stateMisMatch
        }

        let accessTokenRequest = try createAccessTokenRequest(
            authSuccess: authorizationResponse,
            registration: configuration
        )
        let responseData = try await NetworkClient().execute(accessTokenRequest)
        let accessTokenResponse = try decodeAccessTokenResponse(responseData)
        
        return accessTokenResponse
    }

    // MARK: -

    /// - Returns: request for an OAuth2 authorization token
    func createTokenRequest(state: String, method: HTTPMethod) throws -> URLRequest {
        try AuthorizationRequest(
            clientId: configuration.registration.key,
            redirectUri: configuration.registration.callback.absoluteString,
            state: state,
            scope: nil
        ).urlRequest(authorizationRequestURL: configuration.endpoints.authorizationRequestURL, method: method)
    }

    /// - Returns: request for an OAuth2 authorization token response
    /// - Throws: OAuth2Error.invalidCallbackURL if the callback is malformed
    func decodeTokenResponse(_ state: String, _ url: URL) throws -> AuthorizationResponse
    {
        guard let dic = url.queryItemDictionary() else {
            throw OAuth2Error.invalidCallbackURL(URL: url)
        }
        if let success = AuthorizationResponse(queryItemDictionary: dic) {
            return success
        } else if let failure = ResponseError(queryItemDictionary: dic) {
            throw failure
        } else {
            throw OAuth2Error.invalidCallbackURL(URL: url)
        }
    }

    // MARK: - Access token request

    /// - Returns: request for an OAuth2 access token request
    func createAccessTokenRequest(authSuccess: AuthorizationResponse,
                                  registration: OAuth2Configuration) throws -> URLRequest {
        try AccessTokenRequest(
            code: authSuccess.code,
            clientId: configuration.registration.key,
            clientSecret: configuration.registration.secret,
            redirectURI: configuration.registration.callback.absoluteString
        ).urlRequest(authorizationCodeGrantRequestURL: configuration.endpoints.authorizationCodeGrantRequestURL)
    }

    /// - Returns: access token response as a JSON token
    func decodeAccessTokenResponse(_ data: Data) throws -> AccessTokenResponse {
        try JSONDecoder().decode(AccessTokenResponse.self, from: data)
    }
}

private extension String
{
    /// Returns a random alphanumeric string with 32 characters.
    /// Characters are chosen by SystemRandomNumberGenerator, which is cryptographically secure.
    static func randomString(length: UInt) -> String {
        var string = ""
        guard length > 0 else { return string }
        let alphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        for _ in 1...length {
            // Note that: Character("") is never used because alphabet is not empty
            let char = alphabet.randomElement() ?? Character("")
            string.append(char)
        }
        return string
    }
}
