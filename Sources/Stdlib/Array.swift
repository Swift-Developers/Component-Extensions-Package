extension Array where Element: Equatable {
    
    public mutating func update(object: Element, updating: (inout Element) -> Void) {
        if let index = firstIndex(of: object) {
            var element = self[index]
            updating(&element)
            self[index] = element
        }
    }
    
    public func indexs(_ closure: (Element) throws -> Bool) rethrows -> [Int] {
        return try enumerated().reduce(into: [Int]()) {
            if try closure($1.element) {
                $0.append($1.offset)
            }
        }
    }
}

extension Array {
    
    public func filtered<E: Equatable>(duplication path: KeyPath<Element, E>) -> [Element] {
        return reduce(into: [Element]()) { (result, e) in
            let contains = result.contains { $0[keyPath: path] == e[keyPath: path] }
            result += contains ? [] : [e]
        }
    }
    
    public func filtered<E: Equatable>(duplication closure: (Element) throws -> E) rethrows -> [Element] {
        return try reduce(into: [Element]()) { (result, e) in
            let contains = try result.contains { try closure($0) == closure(e) }
            result += contains ? [] : [e]
        }
    }
    
    @discardableResult
    public mutating func filter<E: Equatable>(duplication path: KeyPath<Element, E>) -> [Element] {
        self = filtered(duplication: path)
        return self
    }
    
    @discardableResult
    public mutating func filter<E: Equatable>(duplication closure: (Element) throws -> E) rethrows -> [Element] {
        self = try filtered(duplication: closure)
        return self
    }
}
