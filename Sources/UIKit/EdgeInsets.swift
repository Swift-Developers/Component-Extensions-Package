import UIKit

extension UIEdgeInsets {
    
    public var horizontal: CGFloat { return left + right }
    
    public var vertical: CGFloat { return top + bottom }
    
    public init(_ t: CGFloat, _ l: CGFloat, _ b: CGFloat, _ r: CGFloat) {
        self.init(top: t, left: l, bottom: b, right: r)
    }
    
    public init(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) {
        self.init()
        self.top = top
        self.left = left
        self.bottom = bottom
        self.right = right
    }
    
    public init(horizontal: CGFloat = 0, vertical: CGFloat = 0) {
        self.init(top: vertical/2, left: horizontal/2, bottom: vertical/2, right: horizontal/2)
    }
}
