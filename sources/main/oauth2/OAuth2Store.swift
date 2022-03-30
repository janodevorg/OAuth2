import Foundation
import CodableHelpers
import Keychain

public final class OAuth2Store
{
    private let store: ObservedValueStore

    public init(account: String, accessGroup: String) {
        store = ObservedValueStore(valueStore: ValueKeychainStore(accountName: account, accessGroup: accessGroup))
    }

    public func read() throws -> AccessTokenResponse? {
        guard let string = try store.get() else {
            return nil
        }
        return try AccessTokenResponse.decode(json: string)
    }

    public func write(_ accessToken: AccessTokenResponse?) throws  {
        if let accessToken = accessToken {
            let string = try accessToken.encode()
            try store.set(string)
        } else {
            try store.set(nil)
        }
    }

    @discardableResult
    public func observeTokenChanges(callback: @escaping (AccessTokenResponse?) -> Void) -> Observation {
        store.observeChanges { accessTokenString in
            let tokenResponse = accessTokenString.flatMap {
                try? AccessTokenResponse.decode(json: $0)
            }
            callback(tokenResponse)
        }
    }
}
