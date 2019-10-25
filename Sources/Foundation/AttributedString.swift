import Foundation

extension NSAttributedString {
    
    public func applying(attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        let copy = NSMutableAttributedString(attributedString: self)
        let range = (string as NSString).range(of: string)
        copy.addAttributes(attributes, range: range)
        return copy
    }
    
    public static func + (lhs: NSAttributedString, rhs: String) -> NSAttributedString {
        guard !lhs.string.isEmpty else {
            return rhs.attributed()
        }
        
        let result = NSMutableAttributedString(attributedString: lhs)
        result.append(rhs.attributed(lhs.attributes(at: 0, effectiveRange: nil)))
        return result
    }
}
