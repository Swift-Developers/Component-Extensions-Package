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
    
    public var associated: AssociatedWrapper<Self> {
        get { return AssociatedWrapper(self) }
    }
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
    
    /// 设置关联值 OBJC_ASSOCIATION_ASSIGN
    public func set(assign key: UnsafeRawPointer, _ value: Any) {
        objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_ASSIGN)
    }
    
    /// 设置关联值 OBJC_ASSOCIATION_RETAIN_NONATOMIC / OBJC_ASSOCIATION_RETAIN
    public func set(retain key: UnsafeRawPointer, _ value: Any, _ policy: Policy = .nonatomic) {
        switch policy {
        case .nonatomic:
            objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        case .atomic:
            objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// 设置关联值 OBJC_ASSOCIATION_COPY_NONATOMIC / OBJC_ASSOCIATION_COPY
    public func set(copy key: UnsafeRawPointer, _ value: Any, _ policy: Policy = .nonatomic) {
        switch policy {
        case .nonatomic:
            objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        case .atomic:
            objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_COPY)
        }
    }
}
