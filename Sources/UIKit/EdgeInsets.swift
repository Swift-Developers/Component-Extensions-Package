import UIKit

extension UIEdgeInsets {
    
    public init(_ t: CGFloat, _ l: CGFloat, _ b: CGFloat, _ r: CGFloat) {
        self.init(top: t, left: l, bottom: b, right: r)
    }
    
    public static func make(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> Self {
        return UIEdgeInsets(top, left, bottom, right)
    }
    
    public static func make(horizontal: CGFloat = 0, vertical: CGFloat = 0) -> Self {
        return UIEdgeInsets(top: vertical/2, left: horizontal/2, bottom: vertical/2, right: horizontal/2)
    }
    
    public func with(top value: CGFloat) -> Self {
        var temp = self
        temp.top = value
        return temp
    }
    
    public func with(left value: CGFloat) -> Self {
        var temp = self
        temp.left = value
        return temp
    }
    
    public func with(bottom value: CGFloat) -> Self {
        var temp = self
        temp.bottom = value
        return temp
    }
    
    public func with(right value: CGFloat) -> Self {
        var temp = self
        temp.right = value
        return temp
    }
}
