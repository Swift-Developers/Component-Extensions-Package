//
//  File.swift
//  
//
//  Created by 方林威 on 2022/3/17.
//

import Foundation

public struct KeyPathSingleTypePredicate<Element> {
    
    private let evaluator: (Element, Element) -> Bool
    
    public init(evaluator: @escaping (Element, Element) -> Bool) {
        self.evaluator = evaluator
    }
    
    public func evaluate(for element: Element) -> Bool {
        return evaluator(element, element)
    }
    
    public func evaluate(for leftElement: Element, and rightElement: Element) -> Bool {
        return evaluator(leftElement, rightElement)
    }
}

extension Sequence {
    public func prefix(while predicate: KeyPathSingleTypePredicate<Element>) -> [Self.Element] {
        return prefix(while: { predicate.evaluate(for: $0) })
    }
    
    public func first(where predicate: KeyPathSingleTypePredicate<Element>) -> Element? {
        return first(where: { predicate.evaluate(for: $0)} )
    }
    
    public func filter(where predicate: KeyPathSingleTypePredicate<Element>) -> [Element] {
        return filter { predicate.evaluate(for: $0) }
    }
    
    public func contains(where predicate: KeyPathSingleTypePredicate<Element>) -> Bool {
        return contains(where: { predicate.evaluate(for: $0) })
    }
}

public func && <Element>(_ leftPredicate: KeyPathSingleTypePredicate<Element>, _ rightPredicate: KeyPathSingleTypePredicate<Element>) -> KeyPathSingleTypePredicate<Element> {
    return KeyPathSingleTypePredicate(evaluator: { lhs, rhs in leftPredicate.evaluate(for: lhs, and: rhs) && rightPredicate.evaluate(for: lhs, and: rhs) })
}

public func || <Element>(_ leftPredicate: KeyPathSingleTypePredicate<Element>, _ rightPredicate: KeyPathSingleTypePredicate<Element>) -> KeyPathSingleTypePredicate<Element> {
    return KeyPathSingleTypePredicate(evaluator: { lhs, rhs in leftPredicate.evaluate(for: lhs, and: rhs) || rightPredicate.evaluate(for: lhs, and: rhs) })
}

public prefix func ! <Element>(_ predicate: KeyPathSingleTypePredicate<Element>) -> KeyPathSingleTypePredicate<Element> {
    return KeyPathSingleTypePredicate(evaluator: { lhs, _ in !predicate.evaluate(for: lhs) })
}

public prefix func ! <Element>(_ attribute: KeyPath<Element, Bool>) -> KeyPathSingleTypePredicate<Element> {
    return KeyPathSingleTypePredicate(evaluator: { lhs, _ in !lhs[keyPath: attribute] })
}

public func == <Element, T: Equatable>(_ leftAttribute: KeyPath<Element, T>, _ rightAttribute: KeyPath<Element, T>) -> KeyPathSingleTypePredicate<Element> {
    return KeyPathSingleTypePredicate(evaluator: { lhs, rhs in lhs[keyPath: leftAttribute] == rhs[keyPath: rightAttribute] })
}

public func == <Element, T: Equatable>(_ leftAttribute: KeyPath<Element, T>, _ constant: T) -> KeyPathSingleTypePredicate<Element> {
    return KeyPathSingleTypePredicate(evaluator: { lhs, _ in lhs[keyPath: leftAttribute] == constant })
}

public func == <Element, T: Equatable>(_ constant: T, _ rightAttribute: KeyPath<Element, T>) -> KeyPathSingleTypePredicate<Element> {
    return KeyPathSingleTypePredicate(evaluator: { _, rhs in constant == rhs[keyPath: rightAttribute] })
}

public func != <Element, T: Equatable>(_ leftAttribute: KeyPath<Element, T>, _ rightAttribute: KeyPath<Element, T>) -> KeyPathSingleTypePredicate<Element> {
    return KeyPathSingleTypePredicate(evaluator: { lhs, rhs in lhs[keyPath: leftAttribute] != rhs[keyPath: rightAttribute] })
}

public func != <Element, T: Equatable>(_ leftAttribute: KeyPath<Element, T>, _ constant: T) -> KeyPathSingleTypePredicate<Element> {
    return KeyPathSingleTypePredicate(evaluator: { lhs, _ in lhs[keyPath: leftAttribute] != constant })
}

public func != <Element, T: Equatable>(_ constant: T, _ rightAttribute: KeyPath<Element, T>) -> KeyPathSingleTypePredicate<Element> {
    return KeyPathSingleTypePredicate(evaluator: { _, rhs in constant != rhs[keyPath: rightAttribute] })
}

public func ~= <Element, T> (_ pattern: Range<T>, _ leftAttribute: KeyPath<Element, T>) -> KeyPathSingleTypePredicate<Element> {
    return KeyPathSingleTypePredicate(evaluator: { _, rhs in pattern ~= rhs[keyPath: leftAttribute] })
}

public func ~= <Element, T> (_ pattern: ClosedRange<T>, _ leftAttribute: KeyPath<Element, T>) -> KeyPathSingleTypePredicate<Element> {
    return KeyPathSingleTypePredicate(evaluator: { _, rhs in pattern ~= rhs[keyPath: leftAttribute] })
}

public func ~= <Element>(_ lhs: KeyPathSingleTypePredicate<Element>, rhs: Element) -> Bool {
    return lhs.evaluate(for: rhs)
}

public func <= <Element, T: Comparable>(_ leftAttribute: KeyPath<Element, T>, _ rightAttribute: KeyPath<Element, T>) -> KeyPathSingleTypePredicate<Element> {
    return KeyPathSingleTypePredicate(evaluator: { lhs, rhs in lhs[keyPath: leftAttribute] <= rhs[keyPath: rightAttribute] })
}

public func <= <Element, T: Comparable>(_ attribute: KeyPath<Element, T>, _ treshold: T) -> KeyPathSingleTypePredicate<Element> {
    return KeyPathSingleTypePredicate(evaluator: { lhs, _ in lhs[keyPath: attribute] <= treshold })
}

public func < <Element, T: Comparable>(_ leftAttribute: KeyPath<Element, T>, _ rightAttribute: KeyPath<Element, T>) -> KeyPathSingleTypePredicate<Element> {
    return KeyPathSingleTypePredicate(evaluator: { lhs, rhs in lhs[keyPath: leftAttribute] < rhs[keyPath: rightAttribute] })
}

public func < <Element, T: Comparable>(_ attribute: KeyPath<Element, T>, _ treshold: T) -> KeyPathSingleTypePredicate<Element> {
    return KeyPathSingleTypePredicate(evaluator: { lhs, _ in lhs[keyPath: attribute] < treshold })
}

public func >= <Element, T: Comparable>(_ leftAttribute: KeyPath<Element, T>, _ rightAttribute: KeyPath<Element, T>) -> KeyPathSingleTypePredicate<Element> {
    return KeyPathSingleTypePredicate(evaluator: { lhs, rhs in lhs[keyPath: leftAttribute] >= rhs[keyPath: rightAttribute] })
}

public func >= <Element, T: Comparable>(_ attribute: KeyPath<Element, T>, _ treshold: T) -> KeyPathSingleTypePredicate<Element> {
    return KeyPathSingleTypePredicate(evaluator: { lhs, _ in lhs[keyPath: attribute] >= treshold })
}

public func > <Element, T: Comparable>(_ leftAttribute: KeyPath<Element, T>, _ rightAttribute: KeyPath<Element, T>) -> KeyPathSingleTypePredicate<Element> {
    return KeyPathSingleTypePredicate(evaluator: { lhs, rhs in lhs[keyPath: leftAttribute] > rhs[keyPath: rightAttribute] })
}

public func > <Element, T: Comparable>(_ attribute: KeyPath<Element, T>, _ treshold: T) -> KeyPathSingleTypePredicate<Element> {
    return KeyPathSingleTypePredicate(evaluator: { lhs, _ in lhs[keyPath: attribute] > treshold })
}
