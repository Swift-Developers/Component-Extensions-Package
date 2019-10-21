import Foundation

extension String {
    
    /// 转换为富文本
    /// - Parameter attributes: 属性
    public func attributed(_ attributes: [NSAttributedString.Key: Any] = [:]) -> NSAttributedString {
        return .init(string: self, attributes: attributes)
    }
}
