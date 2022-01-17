import Foundation

extension JSONDecoder {
    
    public func decode<T>(_ type: T.Type, from data: Any?) throws -> T where T : Decodable {
        return try decode(type, from: try _data(data))
    }
}

fileprivate func _data(_ any: Any?) throws -> Data {
    guard let any = any else {
        throw NSError(domain: "空数据", code: 0)
    }
    
    func data(with string: String) throws -> Data  {
        guard let data = string.data(using: .utf8) else {
            throw NSError(domain: "无效类型", code: 1)
        }
        return data
    }
    
    switch any {
    case let value as String:
        return try data(with: value)
        
    case let value where JSONSerialization.isValidJSONObject(value):
        return try JSONSerialization.data(withJSONObject: any)
        
    default:
        /// 其他类型
        return try data(with: "\(any)")
    }
}
