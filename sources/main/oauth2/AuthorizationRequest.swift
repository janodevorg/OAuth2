import APIClient
import Foundation
import os

/**
 OAuth 2 authorization request.

 See [4.1.1 Authorization Request](https://datatracker.ietf.org/doc/html/rfc6749#section-4.1.1)
 */
public struct AuthorizationRequest
{
    private let log = Logger(subsystem: "dev.jano", category: "oauth2")

    /// Client identifier.
    /// See [2.2 Client Identifier](https://datatracker.ietf.org/doc/html/rfc6749#section-2.2)
    public let clientId: String

    /// Redirection URI.
    /// See [3.1.2. Redirection Endpoint](https://datatracker.ietf.org/doc/html/rfc6749#section-3.1.2)
    public let redirectUri: String

    /// Opaque value to be matched against the callback URL to avoid CSRF attacks.
    /// See [10.12. Cross-Site Request Forgery](https://datatracker.ietf.org/doc/html/rfc6749#section-10.12)
    public let state: String

    /// Requested scope for the access token.
    /// See [3.3. Access Token Scope](https://datatracker.ietf.org/doc/html/rfc6749#section-3.3)
    public let scope: String?

    /// A fixed value indicating the response requested.
    public let responseType = "code"

    public func urlRequest(authorizationRequestURL: URL, method: HTTPMethod) throws -> URLRequest
    {
        // add parameters as query items to the endpoint
        // TODO: create an internal function/closure for this block
        var components = URLComponents(url: authorizationRequestURL, resolvingAgainstBaseURL: false)
        components?.queryItems = [
            "client_id": clientId,
            "redirect_uri": redirectUri,
            "response_type": responseType,
            "scope": scope,
            "state": state
            ]
            .compactMap { key, value in
                guard let value = value else { return nil }
                return URLQueryItem(name: key, value: value)
            }
        guard let url = components?.url else {
            throw OAuth2Error.invalidURLRequest /* shouldn’t happen */
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.stringValue
        request.allHTTPHeaderFields = HTTPHeader.acceptJSON.value
            .merging(HTTPHeader.contentTypeJSON.value) { (_, new) in new }

        return request
    }
}
