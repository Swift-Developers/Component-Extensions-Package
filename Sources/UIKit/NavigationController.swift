import UIKit

extension UINavigationController {
    
    /// 获取一个符合类型的视图控制器
    /// - Parameter controller: 控制器类型
    public func first<T: UIViewController>(_ controller: T.Type) -> T? {
        return viewControllers.first { type(of: $0) == controller } as? T
    }
    
    /// 过滤所有符合类型的视图控制器
    /// - Parameter controller: 控制器类型
    public func filter<T: UIViewController>(_ controller: T.Type) -> [T] {
        return viewControllers.filter { type(of: $0) == controller } as? [T] ?? []
    }
    
    /// 移除所有符合类型的视图控制器
    /// - Parameter controller: 控制器类型
    /// - Parameter animated: 是否动画
    @discardableResult
    public func remove<T: UIViewController>(_ controller: T.Type, animated: Bool = false) -> [T]? {
        let controllers = filter(T.self)
        var temp = viewControllers
        temp.removeAll(controllers)
        setViewControllers(temp, animated: animated)
        return controllers
    }
    
    /// 移除一个视图控制器
    /// - Parameter controller: 控制器
    /// - Parameter animated: 是否动画
    public func remove(_ controller: UIViewController, animated: Bool = false) {
        var temp = viewControllers
        temp.removeAll([controller])
        setViewControllers(temp, animated: animated)
    }
    
    /// 移除多个视图控制器
    /// - Parameter controllers: 控制器集合
    /// - Parameter animated: 是否动画
    public func remove(_ controllers: [UIViewController], animated: Bool = false) {
        var temp = viewControllers
        temp.removeAll(controllers)
        setViewControllers(temp, animated: animated)
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
