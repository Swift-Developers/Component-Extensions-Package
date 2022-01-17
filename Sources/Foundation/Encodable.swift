import Foundation

extension Encodable {
    
    @inline(__always)
    public func toJSONData(using encoder: JSONEncoder = .init()) throws -> Data {
        return try encoder.encode(self)
    }
    
    @inline(__always)
    public func toJSONString(using encoder: JSONEncoder = .init()) -> String? {
        guard let data = try? toJSONData(using: encoder) else { return nil }
        
        return String(data: data, encoding: .utf8)
    }
}
