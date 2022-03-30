import Foundation
import Dependency

/**
 OAuth2 client for the Teamwork API.

 Deviations from the standard:

   - The access token response is a JSON object that doesn’t follow the expected format.
     See [4.4.3. Access Token Response](https://datatracker.ietf.org/doc/html/rfc6749#section-4.4.3)
 */
public final class TeamworkOAuth2Client: OAuth2Client
{
    override public init(configuration: OAuth2Configuration) {
        super.init(configuration: configuration)
        ignoreStateCheckOnResponseErrorBecauseMyClientDoesntFollowTheStandard = true
    }

    /// - Returns: access token response as a JSON token
    override func decodeAccessTokenResponse(_ data: Data) throws -> AccessTokenResponse {
        let accessTokenResponse = try JSONDecoder().decode(TeamworkAccessTokenResponse.self, from: data)
        return AccessTokenResponse(
            accessToken: accessTokenResponse.accessToken,
            tokenType: AccessTokenResponse.TokenType.bearer,
            expiresInSeconds: nil,
            refreshToken: nil,
            scope: nil,
            additionalInfo: [
                "APIEndpoint": accessTokenResponse.installation.apiEndPoint
            ]
        )
    }
}
