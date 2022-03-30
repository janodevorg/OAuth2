import Foundation

/**
 A value that represents an access token response.

 Here is a sample JSON this object can be decoded from:
 ```
 {
   "access_token":"2YotnFZFEjr1zCsicMWpAA",
   "token_type":"bearer",
   "expires_in":3600,
   "refresh_token":"tGzv3JOkF0XG5Qx2TlKWIA",
 }
 ```

 See [4.3.3. Access Token Response](https://datatracker.ietf.org/doc/html/rfc6749#section-4.3.3)
 */
public struct AccessTokenResponse: Codable, Equatable, Sendable, CustomDebugStringConvertible
{
    public enum TokenType: String, Codable, Sendable
    {
        /// Bearer token. See RFC6750 [6.1.1. The "Bearer" OAuth Access Token Type](https://datatracker.ietf.org/doc/html/rfc6750#section-6.1.1)
        case bearer = "Bearer"
        // case mac = "mac" // not implemented

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let value = try container.decode(String.self).lowercased().capitalized
            guard let token = TokenType(rawValue: value) else {
                throw DecodingError.valueNotFound(
                    TokenType.self,
                    DecodingError.Context(codingPath: [], debugDescription: "Expected value 'bearer' or 'Bearer'.", underlyingError: nil))
            }
            self = token
        }
    }

    /// Credentials used to access protected resources.
    /// See [1.4 Access Token](https://datatracker.ietf.org/doc/html/rfc6749#section-1.4).
    public let accessToken: String

    /// Indicates how to use the access token to access protected resources.
    /// See [7.1. Access Token Types](https://datatracker.ietf.org/doc/html/rfc6749#section-7.1)
    public let tokenType: TokenType

    /// The lifetime in seconds of the access token.
    public let expiresInSeconds: Int?

    /// Credentials used to obtain access tokens.
    /// See [1.5 Refresh Token](https://datatracker.ietf.org/doc/html/rfc6749#section-1.5).
    public let refreshToken: String?

    /// Scope of the access token.
    /// It is optional when the scope is the same scope requested.
    /// See [3.3. Access Token Scope](https://datatracker.ietf.org/doc/html/rfc6749#section-3.3).
    public let scope: String?

    public var additionalInfo = [String: String]()

    public init(
        accessToken: String,
        tokenType: TokenType,
        expiresInSeconds: Int?,
        refreshToken: String?,
        scope: String?,
        additionalInfo: [String: String])
    {
        self.accessToken = accessToken
        self.tokenType = tokenType
        self.expiresInSeconds = expiresInSeconds
        self.refreshToken = refreshToken
        self.scope = scope
        self.additionalInfo = additionalInfo
    }

    // MARK: - Transforming to JSON

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresInSeconds = "expires_in"
        case refreshToken = "refresh_token"
        case scope = "scope"
        case additionalInfo = "additionalInfo"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.accessToken = try container.decode(String.self, forKey: .accessToken)
        self.tokenType = try container.decode(TokenType.self, forKey: .tokenType)
        self.expiresInSeconds = try container.decodeIfPresent(Int.self, forKey: .expiresInSeconds)
        self.refreshToken = try container.decodeIfPresent(String.self, forKey: .refreshToken)
        self.scope = try container.decodeIfPresent(String.self, forKey: .scope)
        self.additionalInfo = try container.decodeIfPresent([String: String].self, forKey: .additionalInfo) ?? [:]
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(accessToken, forKey: .accessToken)
        try container.encode(tokenType, forKey: .tokenType)
        try container.encode(expiresInSeconds, forKey: .expiresInSeconds)
        try container.encode(refreshToken, forKey: .refreshToken)
        try container.encode(scope, forKey: .scope)
        try container.encode(additionalInfo, forKey: .additionalInfo)
    }

    // MARK: - Debugging

    public var debugDescription: String {
        """
            accessToken: \(accessToken)
            tokenType: \(tokenType.rawValue)
            expiresInSeconds: \(expiresInSeconds as Any)
            refreshToken: \(refreshToken as Any)
            scope: \(scope as Any)
            additionalInfo: \(additionalInfo as Any)
        """
    }
}
