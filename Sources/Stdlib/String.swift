
extension Optional where Wrapped == String {
    
    public var count: Int {
        return self?.count ?? 0
    }
}
