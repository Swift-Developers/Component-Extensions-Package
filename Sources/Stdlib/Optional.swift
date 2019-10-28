
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
