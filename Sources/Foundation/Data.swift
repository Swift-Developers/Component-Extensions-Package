import Foundation

public extension Data {
    
    func toJSON() -> Any? {
        return try? JSONSerialization.jsonObject(
            with: self,
            options: .allowFragments
        )
    }
    
    func to<T>(_ type: T.Type) throws -> T where T: Decodable {
        return try JSONDecoder().decode(type, from: self)
    }
}
