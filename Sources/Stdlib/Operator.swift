//
//  File.swift
//  
//
//  Created by 方林威 on 2022/9/14.
//

import Foundation

public func ~= <Element: Equatable>(_ lhs: Optional<Element>, rhs: [Element]) -> Bool {
    switch lhs {
    case .some(let value):      return rhs.contains(value)
    case .none:                 return false
    }
}

public func ~= <Element: Equatable>(_ lhs: [Element], rhs: Optional<Element>) -> Bool {
    switch rhs {
    case .some(let value):      return lhs.contains(value)
    case .none:                 return false
    }
}

public func ~= <Element: Equatable>(_ lhs: Element, rhs: [Element]) -> Bool {
    rhs.contains(lhs)
}

public func ~= <Element: Equatable>(_ lhs: [Element], rhs: Element) -> Bool {
    lhs.contains(rhs)
}
