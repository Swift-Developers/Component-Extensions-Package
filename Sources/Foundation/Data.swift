import Foundation

public extension Data {
    
    func to<T>(_ type: T.Type) throws -> T where T: Decodable {
        return try JSONDecoder().decode(type, from: self)
    }
}
