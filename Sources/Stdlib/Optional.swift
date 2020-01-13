
extension Optional {
    
    /// 可选值为空的时候返回 true
    var isNone: Bool {
        switch self {
        case .none: return true
        case .some: return false
        }
    }
    
    /// 可选值非空返回 true
    var isSome: Bool {
        return !isNone
    }
    
    /// 返回可选值或默认值
    /// - 参数: 如果可选值为空，将会默认值
    func or(_ default: Wrapped) -> Wrapped {
        return self ?? `default`
    }
    
    /// 返回可选值或 `else` 表达式返回的值
    /// 例如. optional.or(else: print("Arrr"))
    func or(else: @autoclosure () -> Wrapped) -> Wrapped {
        return self ?? `else`()
    }
    
    /// 当可选值不为空时，返回可选值
    /// 如果为空，抛出异常
    func or(throw exception: Error) throws -> Wrapped {
        guard let self = self else { throw exception }
        return self
    }
}

extension Optional where Wrapped == Error {
    
    /// 当可选值不为空时，执行 `else`
    func or(_ else: (Error) -> Void) {
        guard let error = self else { return }
        `else`(error)
    }
}

extension Optional where Wrapped: BinaryFloatingPoint {
    
    /// Check if optional is nil or zero float.
    public var isNilOrZero: Bool {
        guard let float = self else { return true }
        return float.isZero
    }
    
    /// Returns the float only if it is not nill and not zero.
    public var nonZero: Wrapped? {
        guard let float = self else { return nil }
        guard !float.isZero else { return nil }
        return float
    }
}

extension Optional where Wrapped: BinaryInteger {
    
    /// Check if optional is nil or zero integer.
    public var isNilOrZero: Bool {
        guard let integer = self else { return true }
        return integer.isZero
    }
    
    /// Returns the integer only if it is not nill and not zero.
    public var nonZero: Wrapped? {
        guard let integer = self else { return nil }
        guard !integer.isZero else { return nil }
        return integer
    }
}

extension BinaryInteger {
    
    /// Return true if 1, or other if false.
    ///
    ///        0.isZero -> true
    ///        1.isZero -> false
    ///        2.isZero -> false
    ///
    public var isZero: Bool { self == 0 }
}
