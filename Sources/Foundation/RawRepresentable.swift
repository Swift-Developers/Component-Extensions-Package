import Foundation

extension RawRepresentable {
    
    public init?(rawValue: RawValue?) {
        guard let value = rawValue else { return nil }
        self.init(rawValue: value)
    }
}

public func ~= <Value: RawRepresentable>(lhs: Optional<Value>, rhs: Value) -> Bool where Value.RawValue: Equatable {
    switch lhs {
    case .some(let value):  return value == rhs
    case .none:             return false
    }
}

public func ~= <Value: RawRepresentable>(lhs: Value, rhs: Optional<Value>) -> Bool where Value.RawValue: Equatable {
    switch rhs {
    case .some(let value):  return value == lhs
    case .none:             return false
    }
}
