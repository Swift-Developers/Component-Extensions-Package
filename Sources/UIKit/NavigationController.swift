import UIKit

extension UINavigationController {
    
    public func first<T: UIViewController>(_ controller: T.Type) -> T? {
        return viewControllers.first { type(of: $0) == controller } as? T
    }
    
    public func filter<T: UIViewController>(_ controller: T.Type) -> [T]? {
        return viewControllers.filter { type(of: $0) == controller } as? [T]
    }
    
    @discardableResult
    public func remove<T: UIViewController>(_ controller: T.Type, animated: Bool = false) -> [T]? {
        guard let controllers = filter(T.self) else {
            return nil
        }
        
        var temp = viewControllers
        temp.removeAll(controllers)
        setViewControllers(temp, animated: animated)
        return controllers
    }
    
    public func remove(_ controller: UIViewController, animated: Bool = false) {
        var temp = viewControllers
        temp.removeAll([controller])
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
