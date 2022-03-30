@testable import OAuth2
import Foundation
import XCTest

final class OAuth2Tests: XCTestCase
{
    let state = "deadbeef"
    let code = "cafebabe"

    func testParseCallbackSuccess() {
        let url = URL(string: "mountaindew://callback?code=\(code)&state=\(state)&client_id=defaced")!
        let items = url.queryItemDictionary() ?? [:]

        let expected = AuthorizationResponse(queryItemDictionary: ["code": code, "state": state])
        let actual = AuthorizationResponse(queryItemDictionary: items)
        XCTAssertEqual(actual, expected)
    }
}
