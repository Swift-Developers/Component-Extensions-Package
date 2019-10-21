import Foundation

extension NotificationCenter {
    
    public static func post(_ name: Notification.Name,
                            object: Any? = nil,
                            userInfo: [AnyHashable: Any]? = nil) {
        NotificationCenter.default.post(
            name: name,
            object: object,
            userInfo: userInfo
        )
    }
    
    public static func add(_ name: Notification.Name,
                           observer: Any,
                           selector: Selector,
                           object: Any? = nil) {
        NotificationCenter.default.addObserver(
            observer,
            selector: selector,
            name: name,
            object: object
        )
    }
    
    @discardableResult
    public static func add(_ name: Notification.Name,
                           _ object: Any? = nil,
                           queue: OperationQueue = .main,
                           using block: @escaping (Notification) -> Void) -> NSObjectProtocol {
        return NotificationCenter.default.addObserver(
            forName: name,
            object: object,
            queue: .main,
            using: block
        )
    }
    
    public static func remove(_ observer: Any) {
        NotificationCenter.default.removeObserver(observer)
    }
    
    public static func remove(_ name: Notification.Name, observer: Any, object: Any? = nil) {
        NotificationCenter.default.removeObserver(
            observer,
            name: name,
            object: object
        )
    }
}
