import Foundation

extension URL {
    
    public init?(_ base: String, query: [String: Any] = [:]) {
        guard var components = URLComponents(string: base) else {
            return nil
        }
        components.queryItems = query.map { URLQueryItem(name: $0.key, value: "\($0.value)".queryEncoded)}
        guard let url = components.url else { return nil }
        self = url
    }
    
    /// 替换所有Query
    func replacingQueryParameters(_ parameters: [String: Any]) -> URL {
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = parameters.map { URLQueryItem(name: $0, value: "\($1)") }
        return urlComponents.url!
    }
    
    
    /// 移出一个Query
    /// - Parameter key: Query key
    public func removeQuery(for key: String) -> URL {
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true)!
        var items = urlComponents.queryItems ?? []
        items.removeAll { $0.name == key }
        urlComponents.queryItems = items
        return urlComponents.url!
    }
    
    public func removeAllQuery() -> URL {
        replacingQueryParameters([:])
    }
}

extension URL {
    
    public var queryParameters: [String: String] {
        var parameters = [String: String]()
        self.query?.components(separatedBy: "&").forEach { component in
            guard let separatorIndex = component.firstIndex(of: "=") else { return }
            let keyRange = component.startIndex..<separatorIndex
            let valueRange = component.index(after: separatorIndex)..<component.endIndex
            let key = String(component[keyRange])
            let value = component[valueRange].removingPercentEncoding ?? String(component[valueRange])
            parameters[key] = value
        }
        return parameters
    }
}
