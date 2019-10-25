import Dispatch

extension DispatchQueue {
    
    private static func isCurrent(_ queue: DispatchQueue) -> Bool {
        let key = DispatchSpecificKey<Void>()
        
        queue.setSpecific(key: key, value: ())
        defer { queue.setSpecific(key: key, value: nil) }
        
        return getSpecific(key: key) != nil
    }
    
    /// 安全同步执行 (可防止死锁)
    /// - Parameter queue: 队列
    /// - Parameter work: 执行
    public static func sync(safe queue: DispatchQueue, execute work: () -> Void) {
        isCurrent(queue) ? work() : queue.sync(execute: work)
    }
}
