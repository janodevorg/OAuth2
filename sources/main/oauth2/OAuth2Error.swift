import Foundation

/// Errors thrown by the OAuth2 client.
public enum OAuth2Error: Error
{
    /// Error during serialization of credentials
    case failureReadingCredentials(reason: String)

    /// The response is not a HTTP response.
    case expectedHTTPResponse

    /// The response contains a HTTP status error.
    case expectedHTTPSuccess

    /// The callback returned doesn’t contain the expected parameters.
    case invalidCallbackURL(URL: URL)

    /// Couldn’t create a valid URL request with the parameters provided.
    case invalidURLRequest

    /// Registration for the client is not valid.
    case invalidRegistration(reason: String)

    // The state of the authorization request and response doesn’t match.
    case stateMisMatch

    public var localizedResponse: String {
        switch self {
        case .failureReadingCredentials(let reason): return reason
        case .expectedHTTPResponse: return "Not a HTTP response"
        case .expectedHTTPSuccess: return "Expected a HTTP success status"
        case .invalidCallbackURL(URL: let url):
            return "The callback doesn’t contain the expected parameters. Callback was: \(url)"
        case .invalidURLRequest: return "Couldn’t create a valid URL request with the parameters provided"
        case .invalidRegistration(let reason): return reason
        case .stateMisMatch: return "The state of the authorization request and response doesn’t match."
        }
    }
}
