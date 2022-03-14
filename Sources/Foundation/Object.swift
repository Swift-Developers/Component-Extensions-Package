import Foundation

public class AssociatedWrapper<Base> {
   let base: Base
   init(_ base: Base) {
        self.base = base
    }
}

public protocol AssociatedCompatible {
    associatedtype AssociatedCompatibleType
    var associated: AssociatedCompatibleType { get }
}

extension AssociatedCompatible {
    
    public var associated: AssociatedWrapper<Self> { AssociatedWrapper(self) }
}

extension NSObject: AssociatedCompatible { }

extension AssociatedWrapper where Base: NSObject {
    
    public enum Policy {
        case nonatomic
        case atomic
    }
    
    /// 获取关联值
    public func get<T>(_ key: UnsafeRawPointer) -> T? {
        objc_getAssociatedObject(base, key) as? T
    }
    /// 获取关联值   default: 默认值
    public func get<T>(_ key: UnsafeRawPointer, default value: T) -> T {
        guard let value: T = objc_getAssociatedObject(base, key) as? T else {
            objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return value
        }
        return value
    }
    
    /// 设置关联值 OBJC_ASSOCIATION_ASSIGN
    @discardableResult
    public func set<T>(assign key: UnsafeRawPointer, _ value: T) -> T {
        objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_ASSIGN)
        return value
    }
    
    /// 设置关联值 OBJC_ASSOCIATION_RETAIN_NONATOMIC / OBJC_ASSOCIATION_RETAIN
    @discardableResult
    public func set<T>(retain key: UnsafeRawPointer, _ value: T?, _ policy: Policy = .nonatomic) -> T? {
        switch policy {
        case .nonatomic:
            objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        case .atomic:
            objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_RETAIN)
        }
        return value
    }
    
    /// 设置关联值 OBJC_ASSOCIATION_COPY_NONATOMIC / OBJC_ASSOCIATION_COPY
    @discardableResult
    public func set<T>(copy key: UnsafeRawPointer, _ value: T?, _ policy: Policy = .nonatomic) -> T? {
        switch policy {
        case .nonatomic:
            objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        case .atomic:
            objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_COPY)
        }
        return value
    }
}
