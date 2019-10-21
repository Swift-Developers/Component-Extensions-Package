

extension Optional where Wrapped == String {
    
    var count: Int {
        return self?.count ?? 0
    }
}
