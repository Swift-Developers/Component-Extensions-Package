import Foundation

extension NSAttributedString {
    
    public static func + (lhs: NSAttributedString, rhs: String) -> NSAttributedString {
        guard !lhs.string.isEmpty else {
            return rhs.attributed()
        }
        
        let result = NSMutableAttributedString(attributedString: lhs)
        result.append(rhs.attributed(lhs.attributes(at: 0, effectiveRange: nil)))
        return result
    }
}
