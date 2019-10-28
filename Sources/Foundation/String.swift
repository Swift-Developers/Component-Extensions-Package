import Foundation

extension String {
    
    /// 转换为富文本
    /// - Parameter attributes: 属性
    public func attributed(_ attributes: [NSAttributedString.Key: Any] = [:]) -> NSAttributedString {
        return .init(string: self, attributes: attributes)
    }
}

extension String {
    
    /// 转为Date
    /// - Parameter format: 格式
    /// - Parameter locale: 本地化
    public func date(_ format: String = "yyyy-MM-dd HH:mm:ss.0", locale: Locale = .current) -> Date? {
        String.formatter.locale = locale
        String.formatter.dateFormat = format
        return String.formatter.date(from: self)
    }
    
    private static let formatter = DateFormatter()
}
