import Foundation

extension Encodable {
    
    @inline(__always)
    public func jsonData(using encoder: JSONEncoder = .init()) throws -> Data {
        return try encoder.encode(self)
    }
    
    @inline(__always)
    public func jsonString(using encoder: JSONEncoder = .init()) throws -> String? {
        let data = try jsonData(using: encoder)
        return String(data: data, encoding: .utf8)
    }
    
    /// Encodable 类型转 json 字典
    /// - Returns: json 字典
    @inline(__always)
    public func toJSON(using encoder: JSONEncoder = .init(), options: JSONSerialization.ReadingOptions = []) throws -> Any {
        let data = try jsonData(using: encoder)
        return try JSONSerialization.jsonObject(with: data, options: options)
    }
}

extension Encodable where Self == String {
    
    /// 字符串 类型转 data
    /// - Parameter encoder: JSONEncoder
    /// - Returns:  json 字符串
    @inline(__always)
    public func jsonData(using encoder: JSONEncoder = .init()) throws -> Data {
        guard let data = self.data(using: .utf8) else {
            throw NSError(domain: "string to data fail", code: 0)
        }
        return data
    }
    
    @inline(__always)
    public func jsonString(using encoder: JSONEncoder = .init()) throws -> String? {
        self
    }
    
    /// Encodable 类型转 json 字典
    /// - Returns: json 字典
    @inline(__always)
    public func toJSON(using encoder: JSONEncoder = .init(), options: JSONSerialization.ReadingOptions = []) throws -> Any {
        let data = try jsonData(using: encoder)
        return try JSONSerialization.jsonObject(with: data, options: options)
    }
}

extension Encodable where Self == Data {
    
    @inline(__always)
    public func jsonData(using encoder: JSONEncoder = .init()) throws -> Data {
        self
    }
    
    /// Data 类型转 json 字符串
    /// - Parameter encoder: JSONEncoder
    /// - Returns:  json 字符串
    @inline(__always)
    public func jsonString(using encoder: JSONEncoder = .init()) -> String? {
        return String(data: self, encoding: .utf8)
    }
    
    /// Encodable 类型转 json 字典
    /// - Returns: json 字典
    @inline(__always)
    public func toJSON(using encoder: JSONEncoder = .init(), options: JSONSerialization.ReadingOptions = []) throws -> Any {
        return try JSONSerialization.jsonObject(with: self, options: options)
    }
}

extension Array {
    
    /// 数组转JSON字符串
    @inline(__always)
    public func jsonString(using encoder: JSONEncoder = .init()) throws -> String? {
        let data = try JSONSerialization.data(withJSONObject: self, options: .init(rawValue: 0))
        return String(data: data, encoding: .utf8)
    }
}

extension Array where Element: Encodable {
    
    /// 数组转JSON字符串
    @inline(__always)
    public func jsonString(using encoder: JSONEncoder = .init()) throws -> String? {
        let data = try jsonData(using: encoder)
        return String(data: data, encoding: .utf8)
    }
}

extension Encodable {
    
    /// 控制台 打印格式化的json
    /// - Returns: 格式化后的字符串
    public func prettyPrinted() -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try? encoder.encode(self)
        return String(data: data ?? Data(), encoding: .utf8) ?? "Failed to generate JSON string"
    }
}
