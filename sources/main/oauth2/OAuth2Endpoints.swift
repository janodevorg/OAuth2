import Foundation

/// OAuth2 endpoints.
public struct OAuth2Endpoints
{
    /// Endpoint used to request permission from a user to gain access to their account.
    let authorizationRequestURL: URL

    /// Endpoint that exchanges an authorization code for an access token.
    let authorizationCodeGrantRequestURL: URL
}
