import Foundation

/// Response to the authorization request.
public struct AuthorizationResponse: Equatable
{
    /// Authorization code.
    /// See [4.1.2.  Authorization Response](https://datatracker.ietf.org/doc/html/rfc6749#section-4.1.2)
    public let code: String

    /// Value of the 'state' parameter sent during the authentication request.
    /// See [4.1.2.  Authorization Response](https://datatracker.ietf.org/doc/html/rfc6749#section-4.1.2)
    public let state: String

    public init?(queryItemDictionary dic: [String: String])
    {
        guard
            let state = dic["state"],
            let code = dic["code"]
        else {
            return nil
        }

        self.state = state
        self.code = code
    }
}
