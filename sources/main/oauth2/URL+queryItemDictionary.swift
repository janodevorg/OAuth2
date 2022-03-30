import Foundation

extension URL
{
    /// Returns the query items in this URL as a name/value array.
    func queryItemDictionary() -> [String: String]?
    {
        URLComponents(url: self, resolvingAgainstBaseURL: false)?
            .queryItems?
            .reduce(into: [String: String]()) { acc, item in
                item.value.flatMap {
                    value in acc[item.name] = item.value
                }
            }
    }
}
