import Foundation
import APIClient
import TumblrNPF
import os
import XCTest
@testable import MyTumblr

final class TumblrAPIResponseTests: XCTestCase
{
    private let log = Logger(subsystem: "dev.jano", category: "apptests")

    func testTumblrAPIResponse() {
        guard let response: TumblrResponse<BlogPage> = decode(filename: "401.json") else {
            XCTFail("Decoding failed.")
            return
        }
        let status = HTTPStatus(code: response.meta.status)
        XCTAssert(status?.isError == true)
        XCTAssert(status?.code == 401)
    }
}
