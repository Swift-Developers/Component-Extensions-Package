import UIKit

extension UIEdgeInsets {
    
    public init(_ t: CGFloat, _ l: CGFloat, _ b: CGFloat, _ r: CGFloat) {
        self.init(top: t, left: l, bottom: b, right: r)
    }
    // unfortunately. it has to be all of the combinations
    public init(top: CGFloat) {
        self.init(top: top, left: 0, bottom: 0, right: 0)
    }
    
    public init(top: CGFloat, left: CGFloat) {
        self.init(top: top, left: left, bottom: 0, right: 0)
    }
    public init(top: CGFloat, bottom: CGFloat) {
        self.init(top: top, left: 0, bottom: bottom, right: 0)
    }
    public init(top: CGFloat, right: CGFloat) {
        self.init(top: top, left: 0, bottom: 0, right: right)
    }
    
    public init(top: CGFloat, left: CGFloat, bottom: CGFloat) {
        self.init(top: top, left: left, bottom: bottom, right: 0)
    }
    public init(top: CGFloat, left: CGFloat, right: CGFloat) {
        self.init(top: top, left: left, bottom: 0, right: right)
    }
    
    public init(left: CGFloat) {
        self.init(top: 0, left: left, bottom: 0, right: 0)
    }
    
    public init(left: CGFloat, bottom: CGFloat) {
        self.init(top: 0, left: left, bottom: bottom, right: 0)
    }
    public init(left: CGFloat, right: CGFloat) {
        self.init(top: 0, left: left, bottom: 0, right: right)
    }
    
    public init(left: CGFloat, bottom: CGFloat, right: CGFloat) {
        self.init(top: 0, left: left, bottom: bottom, right: right)
    }
    
    public init(bottom: CGFloat) {
        self.init(top: 0, left: 0, bottom: bottom, right: 0)
    }
    public init(bottom: CGFloat, right: CGFloat) {
        self.init(top: 0, left: 0, bottom: bottom, right: right)
    }
    
    public init(right: CGFloat) {
        self.init(top: 0, left: 0, bottom: 0, right: right)
    }
    
    public init(horizontal value: CGFloat) {
        self.init(top: 0, left: value, bottom: 0, right: value)
    }
    public init(vertical value: CGFloat) {
        self.init(top: value, left: 0, bottom: value, right: 0)
    }
    public init(vertical: CGFloat, horizontal: CGFloat) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
}

extension UIEdgeInsets {
    
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

public func + (left: UIEdgeInsets, right: UIEdgeInsets) -> UIEdgeInsets {
    UIEdgeInsets(top: left.top + right.top, left: left.left + right.left, bottom: left.bottom + right.bottom, right: left.right + right.right)
}

public func - (left: UIEdgeInsets, right: UIEdgeInsets) -> UIEdgeInsets {
    UIEdgeInsets(top: left.top - right.top, left: left.left - right.left, bottom: left.bottom - right.bottom, right: left.right - right.right)
}

public func * (left: UIEdgeInsets, right: UIEdgeInsets) -> UIEdgeInsets {
    UIEdgeInsets(top: left.top * right.top, left: left.left * right.left, bottom: left.bottom * right.bottom, right: left.right * right.right)
}

public func / (left: UIEdgeInsets, right: UIEdgeInsets) -> UIEdgeInsets {
    UIEdgeInsets(top: left.top / right.top, left: left.left / right.left, bottom: left.bottom / right.bottom, right: left.right / right.right)
}

public prefix func - (inset: UIEdgeInsets) -> UIEdgeInsets {
    UIEdgeInsets(top: -inset.top, left: -inset.left, bottom: -inset.bottom, right: -inset.right)
}

// MARK: - UIEdgeInsets CGFloat operations

public func + (left: UIEdgeInsets, right: CGFloat) -> UIEdgeInsets {
    UIEdgeInsets(top: left.top + right, left: left.left + right, bottom: left.bottom + right, right: left.right + right)
}

public func - (left: UIEdgeInsets, right: CGFloat) -> UIEdgeInsets {
    UIEdgeInsets(top: left.top - right, left: left.left - right, bottom: left.bottom - right, right: left.right - right)
}

public func * (left: UIEdgeInsets, right: CGFloat) -> UIEdgeInsets {
    UIEdgeInsets(top: left.top * right, left: left.left * right, bottom: left.bottom * right, right: left.right * right)
}

public func / (left: UIEdgeInsets, right: CGFloat) -> UIEdgeInsets {
    UIEdgeInsets(top: left.top / right, left: left.left / right, bottom: left.bottom / right, right: left.right / right)
}
