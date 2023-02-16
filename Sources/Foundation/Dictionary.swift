import Foundation

extension Dictionary where Key == String, Value == String  {
    
    /// 将字典用&拼接成url参数形式字符串
    ///  eg: ["name": "cl", "age": "123"] -> "name=cl&age=123"
    /// - Returns: url query
    public func toQueryString() -> String {
        return compactMap {
            guard !$0.isEmpty, !$1.isEmpty else { return nil }
            guard let _ = Foundation.URL(string: $1) else {
                let encoded = $1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? $1
                return "\($0)=\(encoded)"
            }
            
            let string = "?!@#$^&%*+,:;='\"`<>()[]{}/\\| "
            let character = CharacterSet(charactersIn: string).inverted
            let encoded = $1.addingPercentEncoding(withAllowedCharacters: character) ?? $1
            return "\($0)=\(encoded)"
        }
        .joined(separator: "&")
    }
}
