import CoreGraphics

extension CGPoint {
    
    /// Creates a point with unnamed arguments.
    public init(_ x: CGFloat, _ y: CGFloat) {
        self.init()
        self.x = x
        self.y = y
    }
    
    /// Returns a copy with the x value changed.
    public func with(x: CGFloat) -> CGPoint {
        return CGPoint(x: x, y: y)
    }
    /// Returns a copy with the y value changed.
    public func with(y: CGFloat) -> CGPoint {
        return CGPoint(x: x, y: y)
    }
}
