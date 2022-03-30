import OAuth2
import XCTest

final class OAuth2StoreTests: XCTestCase
{
    private func createStore() throws -> OAuth2Store {

        try OAuth2Store(account: "Twitter", accessGroup: "dev.jano")
    }

    override func tearDown() {
        try? createStore().write(nil)
    }

    func testStore() throws {
        let store = createStore()

        let accessTokenWritten = AccessTokenResponse(
            accessToken: "cafebabe",
            tokenType: .bearer,
            expiresInSeconds: 3600,
            refreshToken: "https://refresh.com/token",
            scope: "email",
            additionalInfo: [
                "idToken": "mystery",
                "API" : "https://api.provider.com"
            ]
        )
        try store.write(accessTokenWritten)
        let accessTokenRead = try store.read()
        XCTAssertEqual(accessTokenWritten, accessTokenRead)
    }
}
