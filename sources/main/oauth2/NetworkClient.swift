import Foundation
import os
import Report

struct NetworkClient
{
    private let log = Logger(subsystem: "dev.jano", category: "oauth2")

    /// Execute a network request.
    func execute(_ request: URLRequest) async throws -> Data
    {
        let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw OAuth2Error.expectedHTTPResponse
        }

        log.trace("\(Report(request: request, response: httpResponse, data: data))")

        if 200..<300 ~= httpResponse.statusCode {
            return data
        }

        // is this data an OAuth error object?
        if let responseError = try? JSONDecoder().decode(ResponseError.self, from: data) {
            throw responseError
        }

        throw OAuth2Error.expectedHTTPSuccess
    }
}
