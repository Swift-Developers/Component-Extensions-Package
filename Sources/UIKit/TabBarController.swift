import UIKit

extension UITabBarController {
    
    /// 获取一个符合类型的视图控制器
    /// - Parameter controller: 控制器类型
    public func first<T: UIViewController>(_ controller: T.Type) -> T? {
        return children.first { type(of: $0) == controller } as? T
    }
    
    /// 过滤所有符合类型的视图控制器
    /// - Parameter controller: 控制器类型
    public func filter<T: UIViewController>(_ controller: T.Type) -> [T] {
        return children.filter { type(of: $0) == controller } as? [T] ?? []
    }
    
    public func contains<T: UIViewController>(_ controller: T.Type) -> Bool {
        return children.contains { type(of: $0) == controller }
    }
    
    /// 移除所有符合类型的视图控制器
    /// - Parameter controller: 控制器类型
    /// - Parameter animated: 是否动画
    @discardableResult
    public func remove<T: UIViewController>(_ controller: T.Type, animated: Bool = false) -> [T]? {
        let controllers = filter(T.self)
        var temp = customizableViewControllers ?? []
        let other = children.filter { !temp.contains($0) }
        temp.removeAll(controllers)
        setViewControllers(temp, animated: animated)
        other.forEach { addChild($0) }
        return controllers
    }
    
    /// 移除一个视图控制器
    /// - Parameter controller: 控制器
    /// - Parameter animated: 是否动画
    public func remove(_ controller: UIViewController, animated: Bool = false) {
        var temp = customizableViewControllers ?? []
        let other = children.filter { !temp.contains($0) }
        temp.removeAll([controller])
        setViewControllers(temp, animated: animated)
        other.forEach { addChild($0) }
    }
    
    /// 移除多个视图控制器
    /// - Parameter controllers: 控制器集合
    /// - Parameter animated: 是否动画
    public func remove(_ controllers: [UIViewController], animated: Bool = false) {
        var temp = customizableViewControllers ?? []
        let other = children.filter { !temp.contains($0) }
        temp.removeAll(controllers)
        setViewControllers(temp, animated: animated)
        other.forEach { addChild($0) }
    }
    
    public func insertChild(_ newElement: UIViewController, at i: Int, animated: Bool = false) {
        var temp = customizableViewControllers ?? []
        let other = children.filter { !temp.contains($0) }
        temp.insert(newElement, at: i)
        setViewControllers(temp, animated: animated)
        other.forEach { addChild($0) }
    }
}

fileprivate extension Array where Element: Equatable {
    
    @discardableResult
    mutating func removeAll(_ items: [Element]) -> [Element] {
        guard !items.isEmpty else { return self }
        removeAll(where: { items.contains($0) })
        return self
    }
}
