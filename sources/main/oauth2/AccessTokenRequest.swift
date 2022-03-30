import APIClient
import Foundation

/**
 Access token request.

 See [4.1.3. Access Token Request](https://datatracker.ietf.org/doc/html/rfc6749#section-4.1.3).
 */
public struct AccessTokenRequest
{
    /// Authorization code received as response for the authorization request.
    public let code: String

    /// Client identifier issued during registration.
    public let clientId: String

    /// Client secret issued during registration.
    public let clientSecret: String

    /// Fixed value.
    public let grantType = "authorization_code"

    /// Redirect URI sent on the authorization request.
    public let redirectURI: String

    /**
     Creates a URL request that asks the resource server for an access token.

     - Parameter authorizationCodeGrantRequestURL: Endpoint of the resource server that returns
     access tokens.
     - Returns: A URL request that asks the resource server for an access token.
     */
    public func urlRequest(authorizationCodeGrantRequestURL: URL) throws -> URLRequest
    {
        let parameters = [
            "code": code,
            "grant_type": grantType,
            "redirect_uri": redirectURI,
            "client_id": clientId,
            "client_secret": clientSecret
        ]
        var request = URLRequest(url: authorizationCodeGrantRequestURL)
        request.httpMethod = HTTPMethod.post.stringValue
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        request.allHTTPHeaderFields = HTTPHeader.contentTypeJSON.value
        return request
    }
}
