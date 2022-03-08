import CoreGraphics

extension CGSize {
    
    /// Creates a size with unnamed arguments.
    public init(_ width: CGFloat, _ height: CGFloat) {
        self.init()
        self.width = width
        self.height = height
    }
    
    public init(width: CGFloat) {
        self.init()
        self.width = width
        self.height = 0
    }
    
    public init(height: CGFloat = .zero) {
        self.init()
        self.width = 0
        self.height = height
    }
    
    /// Returns a copy with the width value changed.
    public func with(width: CGFloat) -> CGSize {
        return .init(width: width, height: height)
    }
    /// Returns a copy with the height value changed.
    public func with(height: CGFloat) -> CGSize {
        return .init(width: width, height: height)
    }
}



extension CGSize {
    public var transposed: CGSize {
        CGSize(width: height, height: width)
    }
    
    public func transform(_ trans: CGAffineTransform) -> CGSize {
        applying(trans)
    }
    
    public func size(fill: CGSize) -> CGSize {
        self * max(fill.width / width, fill.height / height)
    }
    
    public func size(fillIfSmaller fill: CGSize) -> CGSize {
        self * max(1, max(fill.width / width, fill.height / height))
    }
    
    public func size(fit: CGSize) -> CGSize {
        self * min(fit.width / width, fit.height / height)
    }
    
    public func size(fitIfBigger fit: CGSize) -> CGSize {
        self * min(1, min(fit.width / width, fit.height / height))
    }
    
    public func rounded(_ scale: CGFloat = 1) -> CGSize {
        CGSize(width: (width * scale).rounded(.up) / scale, height: (height * scale).rounded(.up) / scale)
    }
}

extension CGSize: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(width)
        hasher.combine(height)
    }
}

public func abs(_ left: CGSize) -> CGSize {
    CGSize(width: abs(left.width), height: abs(left.height))
}

public func min(_ left: CGSize, _ right: CGSize) -> CGSize {
    CGSize(width: min(left.width, right.width), height: min(left.height, right.height))
}

// MARK: - CGSize operations

public func + (left: CGSize, right: CGSize) -> CGSize {
    CGSize(width: left.width + right.width, height: left.height + right.height)
}

public func - (left: CGSize, right: CGSize) -> CGSize {
    CGSize(width: left.width - right.width, height: left.height - right.height)
}

public func * (left: CGSize, right: CGSize) -> CGSize {
    CGSize(width: left.width * right.width, height: left.height * right.height)
}

public func / (left: CGSize, right: CGSize) -> CGSize {
    CGSize(width: left.width / right.width, height: left.height / right.height)
}

public prefix func - (size: CGSize) -> CGSize {
    CGSize.zero - size
}

public func += (left: inout CGSize, right: CGSize) {
    left.width += right.width
    left.height += right.height
}

// MARK: - CGSize CGFloat operations

public func + (left: CGSize, right: CGFloat) -> CGSize {
    CGSize(width: left.width + right, height: left.height + right)
}

public func - (left: CGSize, right: CGFloat) -> CGSize {
    CGSize(width: left.width - right, height: left.height - right)
}

public func * (left: CGSize, right: CGFloat) -> CGSize {
    CGSize(width: left.width * right, height: left.height * right)
}

public func / (left: CGSize, right: CGFloat) -> CGSize {
    CGSize(width: left.width / right, height: left.height / right)
}

public func + (left: CGFloat, right: CGSize) -> CGSize {
    CGSize(width: left + right.height, height: left + right.height)
}

public func - (left: CGFloat, right: CGSize) -> CGSize {
    CGSize(width: left - right.height, height: left - right.height)
}

public func * (left: CGFloat, right: CGSize) -> CGSize {
    CGSize(width: left * right.height, height: left * right.height)
}

public func / (left: CGFloat, right: CGSize) -> CGSize {
    CGSize(width: left / right.height, height: left / right.height)
}

// MARK: - CGSize CGPoint operations

public func + (left: CGSize, right: CGPoint) -> CGSize {
    CGSize(width: left.width + right.x, height: left.height + right.y)
}

public func - (left: CGSize, right: CGPoint) -> CGSize {
    CGSize(width: left.width - right.x, height: left.height - right.y)
}

public func * (left: CGSize, right: CGPoint) -> CGSize {
    CGSize(width: left.width * right.x, height: left.height * right.y)
}

public func / (left: CGSize, right: CGPoint) -> CGSize {
    CGSize(width: left.width / right.x, height: left.height / right.y)
}

