import Foundation

/*
 teamworkmobiledesign://callback
 ? error=access_denied
 & error_description=user%20cancelled%20the%20login%20process
 & client_id=726db42afab9fbecb18e106bb8fd33e04204fe12
 */

/// Error response to an authorization request.
///
/// See [4.1.2.1. Error Response](https://datatracker.ietf.org/doc/html/rfc6749#section-4.1.2.1)
public struct ResponseError: Error, Codable, CustomStringConvertible
{
    public let error: ErrorType

    /// Human-readable [ASCII](https://datatracker.ietf.org/doc/html/rfc6749#ref-USASCII) text
    /// providing additional information, used to assist the client developer in understanding the
    /// error that occurred.
    public let errorDescription: String?

    /// A URI identifying a human-readable web page with information about the error, used to
    /// provide the client developer with additional information about the error.
    public let errorURI: String?

    /// Required if a "state" parameter was present in the client authorization request. The exact
    /// value received from the client.
    public let state: String?

    enum CodingKeys: String, CodingKey {
        case error
        case errorDescription = "error_description"
        case errorURI = "error_uri"
        case state
    }

    /// Errors described in
    /// [4.1.2.1. Error Response](https://datatracker.ietf.org/doc/html/rfc6749#section-4.1.2.1)
    public enum ErrorType: String, Codable {

        /// The request is missing a required parameter, includes an invalid parameter value,
        /// includes a parameter more than once, or is otherwise malformed.
        case invalidRequest = "invalid_request"

        /// The client is not authorized to request an authorization code using this method.
        case unauthorizedClient = "unauthorized_client"

        /// The resource owner or authorization server denied the request.
        case accessDenied = "access_denied"

        /// The authorization server does not support obtaining an authorization code using this method.
        /// This is returned by Tumblr and it’s not part of the standard.
        case unsupportedResponseType = "unsupported_response_type"

        /// The requested scope is invalid, unknown, or malformed.
        case invalidScope = "invalid_scope"

        /// The redirect URI doesn’t match the URI registered
        case redirect_uri_mismatch = "redirect_uri_mismatch"

        /// The authorization server encountered an unexpected condition that prevented it from
        /// fulfilling the request. (This error code is needed because a 500 Internal Server Error
        /// HTTP status code cannot be returned to the client via an HTTP redirect.)
        case serverError = "server_error"

        /// The authorization server is currently unable to handle the request due to a temporary
        /// overloading or maintenance of the server.
        case temporarilyUnavailable = "temporarily_unavailable"
    }

    /// Creates an instance with the query items of a callback URL.
    /// - Parameter dic: Query items from a callback URL.
    public init?(queryItemDictionary dic: [String: String])
    {
        guard
            let rawError = dic["error"],
            let error = ErrorType(rawValue: rawError)
        else {
            return nil
        }
        self.error = error
        self.state = dic["state"]
        self.errorDescription = dic["error_description"]
        self.errorURI = dic["error_uri"]
    }

    /// Human readable description for debugging purposes.
    public var description: String {
        [
            "error": error.rawValue,
            "state": state,
            "errorDescription": errorDescription?.replacingOccurrences(of: "+", with: " ") ?? "",
            "errorURI": errorURI
        ]
            .compactMap { key, value in
                guard let value = value else { return nil }
                return "\(key)=\(value)"
            }
            .joined(separator: ",")
    }
}
