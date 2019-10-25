extension Array where Element: Equatable {
    
    /// 更新某个元素
    /// - Parameter object: 元素
    /// - Parameter updating: 更新闭包
    public mutating func update(object: Element, updating: (inout Element) -> Void) {
        if let index = firstIndex(of: object) {
            var element = self[index]
            updating(&element)
            self[index] = element
        }
    }
    
    
    /// 获取符合条件的下标集合
    /// - Parameter closure: 条件闭包
    public func indexs(_ closure: (Element) throws -> Bool) rethrows -> [Index] {
        return try enumerated().reduce(into: [Index]()) {
            if try closure($1.element) {
                $0.append($1.offset)
            }
        }
    }
}

extension Array {
    
    /// 过滤重复元素
    /// - Parameter path: KeyPath条件
    public func filtered<E: Equatable>(duplication path: KeyPath<Element, E>) -> [Element] {
        return reduce(into: [Element]()) { (result, e) in
            let contains = result.contains { $0[keyPath: path] == e[keyPath: path] }
            result += contains ? [] : [e]
        }
    }
    
    /// 过滤重复元素
    /// - Parameter closure: 过滤条件
    public func filtered<E: Equatable>(duplication closure: (Element) throws -> E) rethrows -> [Element] {
        return try reduce(into: [Element]()) { (result, e) in
            let contains = try result.contains { try closure($0) == closure(e) }
            result += contains ? [] : [e]
        }
    }
    
    /// 过滤重复元素
    /// - Parameter path: KeyPath条件
    @discardableResult
    public mutating func filter<E: Equatable>(duplication path: KeyPath<Element, E>) -> [Element] {
        self = filtered(duplication: path)
        return self
    }
    
    /// 过滤重复元素
    /// - Parameter closure: 过滤条件
    @discardableResult
    public mutating func filter<E: Equatable>(duplication closure: (Element) throws -> E) rethrows -> [Element] {
        self = try filtered(duplication: closure)
        return self
    }
}

extension Array {
    
    /// 安全移除第一个元素
    @discardableResult
    public mutating func safeRemoveFirst() -> Element? {
        guard !isEmpty else {
            return nil
        }
        return removeFirst()
    }
    
    /// 安全移除最后一个元素
    @discardableResult
    public mutating func safeRemoveLast() -> Element? {
        guard !isEmpty else {
            return nil
        }
        return removeLast()
    }
}
