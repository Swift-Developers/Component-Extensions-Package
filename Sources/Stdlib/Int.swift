extension Int {
    
    public var bool: Bool { self > 0 }
    
    public var nilIfZero: Int? {
        isZero ? nil : self
    }
}
