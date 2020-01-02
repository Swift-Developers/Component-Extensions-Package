import CoreGraphics

extension CGRect {
    
    /// Creates a rect with unnamed arguments.
    public init(_ origin: CGPoint = .zero, _ size: CGSize = .zero) {
        self.init()
        self.origin = origin
        self.size = size
    }
    
    /// Creates a rect with unnamed arguments.
    public init(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) {
        self.init()
        self.origin = CGPoint(x: x, y: y)
        self.size = CGSize(width: width, height: height)
    }
    
    // MARK: access shortcuts
    /// Alias for origin.x.
    public var x: CGFloat {
        get { origin.x }
        set { origin.x = newValue }
    }
    /// Alias for origin.y.
    public var y: CGFloat {
        get { origin.y }
        set { origin.y = newValue }
    }
    
    /// Accesses origin.x + 0.5 * size.width.
    public var centerX: CGFloat {
        get { x + width * 0.5 }
        set { x = newValue - width * 0.5}
    }
    /// Accesses origin.y + 0.5 * size.height.
    public var centerY: CGFloat {
        get { y + height * 0.5 }
        set { y = newValue - height * 0.5 }
    }
    
    // MARK: edges
    /// Alias for origin.x.
    public var left: CGFloat {
        get { origin.x }
        set { origin.x = newValue }
    }
    /// Accesses origin.x + size.width.
    public var right: CGFloat {
        get { x + width }
        set { x = newValue - width }
    }
    
    #if os(iOS)
    /// Alias for origin.y.
    public var top: CGFloat {
        get { y }
        set { y = newValue }
    }
    /// Accesses origin.y + size.height.
    public var bottom: CGFloat {
        get { y + height }
        set { y = newValue - height }
    }
    #else
    /// Accesses origin.y + size.height.
    public var top: CGFloat {
        get { y + height }
        set { y = newValue - height }
    }
    /// Alias for origin.y.
    public var bottom: CGFloat {
        get { y }
        set { y = newValue }
    }
    #endif
    
    // MARK: points
    /// Accesses the point at the top left corner.
    public var topLeft: CGPoint {
        get { .init(x: left, y: top) }
        set { left = newValue.x; top = newValue.y }
    }
    /// Accesses the point at the middle of the top edge.
    public var topCenter: CGPoint {
        get { .init(x: centerX, y: top) }
        set { centerX = newValue.x; top = newValue.y }
    }
    /// Accesses the point at the top right corner.
    public var topRight: CGPoint {
        get { .init(x: right, y: top) }
        set { right = newValue.x; top = newValue.y }
    }
    
    /// Accesses the point at the middle of the left edge.
    public var centerLeft: CGPoint {
        get { .init(x: left, y: centerY) }
        set { left = newValue.x; centerY = newValue.y }
    }
    /// Accesses the point at the center.
    public var center: CGPoint {
        get { .init(x: centerX, y: centerY) }
        set { centerX = newValue.x; centerY = newValue.y }
    }
    /// Accesses the point at the middle of the right edge.
    public var centerRight: CGPoint {
        get { .init(x: right, y: centerY) }
        set { right = newValue.x; centerY = newValue.y }
    }
    
    /// Accesses the point at the bottom left corner.
    public var bottomLeft: CGPoint {
        get { .init(x: left, y: bottom) }
        set { left = newValue.x; bottom = newValue.y }
    }
    /// Accesses the point at the middle of the bottom edge.
    public var bottomCenter: CGPoint {
        get { .init(x: centerX, y: bottom) }
        set { centerX = newValue.x; bottom = newValue.y }
    }
    /// Accesses the point at the bottom right corner.
    public var bottomRight: CGPoint {
        get { .init(x: right, y: bottom) }
        set { right = newValue.x; bottom = newValue.y }
    }
    
    // MARK: with
    /// Returns a copy with the origin value changed.
    public func with(origin: CGPoint) -> CGRect {
        return .init(origin: origin, size: size)
    }
    /// Returns a copy with the x and y values changed.
    public func with(x: CGFloat, y: CGFloat) -> CGRect {
        return with(origin: .init(x: x, y: y))
    }
    /// Returns a copy with the x value changed.
    public func with(x: CGFloat) -> CGRect {
        return with(x: x, y: y)
    }
    /// Returns a copy with the y value changed.
    public func with(y: CGFloat) -> CGRect {
        return with(x: x, y: y)
    }
    
    /// Returns a copy with the size value changed.
    public func with(size: CGSize) -> CGRect {
        return .init(origin: origin, size: size)
    }
    /// Returns a copy with the width and height values changed.
    public func with(width: CGFloat, height: CGFloat) -> CGRect {
        return with(size: .init(width: width, height: height))
    }
    /// Returns a copy with the width value changed.
    public func with(width: CGFloat) -> CGRect {
        return with(width: width, height: height)
    }
    /// Returns a copy with the height value changed.
    public func with(height: CGFloat) -> CGRect {
        return with(width: width, height: height)
    }
    
    /// Returns a copy with the x and width values changed.
    public func with(x: CGFloat, width: CGFloat) -> CGRect {
        return .init(origin: .init(x: x, y: y), size: .init(width: width, height: height))
    }
    /// Returns a copy with the y and height values changed.
    public func with(y: CGFloat, height: CGFloat) -> CGRect {
        return .init(origin: .init(x: x, y: y), size: .init(width: width, height: height))
    }
    
    // MARK: offset
    /// Returns a copy with the x and y values offset.
    public func offsetBy(dx: CGFloat, _ dy: CGFloat) -> CGRect {
        return with(x: x + dx, y: y + dy)
    }
    /// Returns a copy with the x value values offset.
    public func offsetBy(dx: CGFloat) -> CGRect {
        return with(x: x + dx)
    }
    /// Returns a copy with the y value values offset.
    public func offsetBy(dy: CGFloat) -> CGRect {
        return with(y: y + dy)
    }
    /// Returns a copy with the x and y values offset.
    public func offsetBy(by: CGSize) -> CGRect {
        return with(x: x + by.width, y: y + by.height)
    }
    
    /// Modifies the x and y values by offsetting.
    public func offsetInPlace(dx: CGFloat, _ dy: CGFloat) -> CGRect {
        return .init(x: x + dx, y: y + dy, width: width, height: height)
    }
    /// Modifies the x value values by offsetting.
    public func offsetInPlace(dx: CGFloat) -> CGRect {
        return offsetInPlace(dx: dx, 0)
    }
    /// Modifies the y value values by offsetting.
    public func offsetInPlace(dy: CGFloat) -> CGRect {
        return offsetInPlace(dx: 0, dy)
    }
    /// Modifies the x and y values by offsetting.
    public func offsetInPlace(by size: CGSize) -> CGRect {
        return offsetInPlace(dx: size.width, size.height)
    }
    
    // MARK: inset
    /// Returns a copy inset on all edges by the same value.
    public func insetBy(by value: CGFloat) -> CGRect {
        return insetBy(dx: value, dy: value)
    }
    
    /// Returns a copy inset on the left and right edges.
    public func insetBy(dx: CGFloat) -> CGRect {
        return with(x: x + dx, width: width - dx * 2)
    }
    /// Returns a copy inset on the top and bottom edges.
    public func insetBy(dy: CGFloat) -> CGRect {
        return with(y: y + dy, height: height - dy * 2)
    }
    
    /// Returns a copy inset on all edges by different values.
    public func insetBy(minX: CGFloat = 0, minY: CGFloat = 0, maxX: CGFloat = 0, maxY: CGFloat = 0) -> CGRect {
        return .init(x: x + minX, y: y + minY, width: width - minX - maxX, height: height - minY - maxY)
    }
    
    /// Returns a copy inset on all edges by different values.
    public func insetBy(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> CGRect {
        #if os(iOS)
        return .init(x: x + left, y: y + top, width: width - right - left, height: height - top - bottom)
        #else
        return .init(x: x + left, y: y + bottom, width: width - right - left, height: height - top - bottom)
        #endif
    }
    
    /// Returns a copy inset on the top and left edges.
    public func insetBy(topLeft: CGSize) -> CGRect {
        return insetBy(top: topLeft.height, left: topLeft.width)
    }
    /// Returns a copy inset on the top and right edges.
    public func insetBy(topRight: CGSize) -> CGRect {
        return insetBy(top: topRight.height, right: topRight.width)
    }
    /// Returns a copy inset on the bottom and left edges.
    public func insetBy(bottomLeft: CGSize) -> CGRect {
        return insetBy(left: bottomLeft.width, bottom: bottomLeft.height)
    }
    /// Returns a copy inset on the bottom and right edges.
    public func insetBy(bottomRight: CGSize) -> CGRect {
        return insetBy(bottom: bottomRight.height, right: bottomRight.width)
    }
    
    /// Modifies all values by insetting all edges by the same value.
    public func insetInPlace(by value: CGFloat) -> CGRect {
        return insetBy(top: value, left: value, bottom: value, right: value)
    }
    
    /// Modifies all values by insetting on the left and right edges.
    public func insetInPlace(dx: CGFloat) -> CGRect {
        return insetBy(left: dx, right: dx)
    }
    /// Modifies all values by insetting on the top and bottom edges.
    public func insetInPlace(dy: CGFloat) -> CGRect {
        return insetBy(top: dy, bottom: dy)
    }
    
    /// Modifies all values by insetting all edges by different value.
    public func insetInPlace(minX: CGFloat = 0, minY: CGFloat = 0, maxX: CGFloat = 0, maxY: CGFloat = 0) -> CGRect {
        return insetBy(minX: minX, minY: minY, maxX: maxX, maxY: maxY)
    }
    
    /// Modifies all values by insetting all edges by different value.
    public func insetInPlace(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> CGRect {
        return insetBy(top: top, left: left, bottom: bottom, right: right)
    }
    
    /// Modifies all values by insetting the top and left edges.
    public func insetInPlace(topLeft: CGSize) -> CGRect {
        return insetBy(topLeft: topLeft)
    }
    /// Modifies all values by insetting the top and right edges.
    public func insetInPlace(topRight: CGSize) -> CGRect {
        return insetBy(topRight: topRight)
    }
    /// Modifies all values by insetting the bottom and left edges.
    public func insetInPlace(bottomLeft: CGSize) -> CGRect {
        return insetBy(bottomLeft: bottomLeft)
    }
    /// Modifies all values by insetting the bottom and right edges.
    public func insetInPlace(bottomRight: CGSize) -> CGRect {
        return insetBy(bottomRight: bottomRight)
    }
    
    // MARK: extending
    /// Returns a copy extended on all edges by different values.
    public func extendBy(dx: CGFloat, dy: CGFloat = 0) -> CGRect {
        return insetBy(dx: -dx, dy: -dy)
    }
    /// Returns a copy extended on the top and bottom edges.
    public func extendBy(dy: CGFloat) -> CGRect {
        return insetBy(dy: -dy)
    }
    
    /// Returns a copy extended on all edges by the same value.
    public func extendBy(by: CGFloat) -> CGRect {
        return insetBy(dx: -by, dy: -by)
    }
    
    /// Returns a copy extended on all edges by different values.
    public func extendBy(minX: CGFloat = 0, minY: CGFloat = 0, maxX: CGFloat = 0, maxY: CGFloat = 0) -> CGRect {
        return insetBy(minX: -minX, minY: -minY, maxX: -maxX, maxY: -maxY)
    }
    /// Returns a copy extended on all edges by different values.
    public func extendBy(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> CGRect {
        return insetBy(top: -top, left: -left, bottom: -bottom, right: -right)
    }
    
    /// Modifies all values by extending the top and left edges.
    public func extendBy(topLeft: CGSize) -> CGRect {
        return extendBy(top: topLeft.height, left: topLeft.width)
    }
    /// Modifies all values by extending the top and right edges.
    public func extendBy(topRight: CGSize) -> CGRect {
        return insetBy(top: -topRight.height, right: -topRight.width)
    }
    /// Modifies all values by extending the bottom and left edges.
    public func extendBy(bottomLeft: CGSize) -> CGRect {
        return insetBy(left: -bottomLeft.width, bottom: -bottomLeft.height)
    }
    /// Modifies all values by extending the bottom and right edges.
    public func extendBy(bottomRight: CGSize) -> CGRect {
        return insetBy(bottom: -bottomRight.height, right: -bottomRight.width)
    }
    
    /// Modifies all values by extending all edges by different values.
    public func extendInPlace(dx: CGFloat, dy: CGFloat = 0) -> CGRect {
        return insetBy(dx: -dx, dy: -dy)
    }
    /// Modifies all values by extending the top and bottom edges.
    public func extendInPlace(dy: CGFloat) -> CGRect {
        return insetBy(dy: -dy)
    }
    
    /// Modifies all values by extending all edges by the same value.
    public func extendInPlace(by: CGFloat) -> CGRect {
        return insetBy(dx: -by, dy: -by)
    }
    
    /// Modifies all values by extending all edges by different values.
    public func extendInPlace(minX: CGFloat = 0, minY: CGFloat = 0, maxX: CGFloat = 0, maxY: CGFloat = 0) -> CGRect {
        return insetBy(minX: -minX, minY: -minY, maxX: -maxX, maxY: -maxY)
    }
    /// Modifies all values by extending all edges by different values.
    public func extendInPlace(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> CGRect {
        return insetBy(top: -top, left: -left, bottom: -bottom, right: -right)
    }
    
    /// Modifies all values by extending the top and left edges.
    public func extendInPlace(topLeft: CGSize) -> CGRect {
        return extendBy(top: topLeft.height, left: topLeft.width)
    }
    /// Modifies all values by extending the top and right edges.
    public func extendInPlace(topRight: CGSize) -> CGRect {
        return insetBy(top: -topRight.height, right: -topRight.width)
    }
    /// Modifies all values by extending the bottom and left edges.
    public func extendInPlace(bottomLeft: CGSize) -> CGRect {
        return insetBy(left: -bottomLeft.width, bottom: -bottomLeft.height)
    }
    /// Modifies all values by extending the bottom and right edges.
    public func extendInPlace(bottomRight: CGSize) -> CGRect {
        return insetBy(bottom: -bottomRight.height, right: -bottomRight.width)
    }
    
    // MARK: sizes
    /// Returns a rect of the specified size centered in this rect.
    public func center(_ size: CGSize) -> CGRect {
        let dx = width - size.width
        let dy = height - size.height
        return .init(x: x + dx * 0.5, y: y + dy * 0.5, width: size.width, height: size.height)
    }
    
    /// Returns a rect of the specified size centered in this rect touching the specified edge.
    public func center(_ size: CGSize, alignTo edge: CGRectEdge) -> CGRect {
        return .init(origin: alignedOrigin(size, edge: edge), size: size)
    }
    
    private func alignedOrigin(_ size: CGSize, edge: CGRectEdge) -> CGPoint {
        let dx = width - size.width
        let dy = height - size.height
        switch edge {
        case .minXEdge:     return .init(x: x, y: y + dy * 0.5)
        case .minYEdge:     return .init(x: x + dx * 0.5, y: y)
        case .maxXEdge:     return .init(x: x + dx, y: y + dy * 0.5)
        case .maxYEdge:     return .init(x: x + dx * 0.5, y: y + dy)
        }
    }
    
    /// Returns a rect of the specified size centered in this rect touching the specified corner.
    public func align(_ size: CGSize, corner e1: CGRectEdge, _ e2: CGRectEdge) -> CGRect {
        return .init(origin: alignedOrigin(size, corner: e1, e2), size: size)
    }
    
    private func alignedOrigin(_ size: CGSize, corner e1: CGRectEdge, _ e2: CGRectEdge) -> CGPoint {
        let dx = width - size.width
        let dy = height - size.height
        switch (e1, e2) {
        case (.minXEdge, .minYEdge), (.minYEdge, .minXEdge):
            return CGPoint(x: x, y: y)
            
        case (.maxXEdge, .minYEdge), (.minYEdge, .maxXEdge):
            return CGPoint(x: x + dx, y: y)
            
        case (.minXEdge, .maxYEdge), (.maxYEdge, .minXEdge):
            return CGPoint(x: x, y: y + dy)
            
        case (.maxXEdge, .maxYEdge), (.maxYEdge, .maxXEdge):
            return CGPoint(x: x + dx, y: y + dy)
            
        default:
            preconditionFailure("Cannot align to this combination of edges")
        }
    }
    
    /// Modifies all values by setting the size while centering the rect.
    public func centerInPlace(size: CGSize) -> CGRect {
        return center(size)
    }
    
    /// Modifies all values by setting the size while centering the rect touching the specified edge.
    public func centerInPlace(size: CGSize, alignTo edge: CGRectEdge) -> CGRect {
        return center(size, alignTo: edge)
    }
    
    /// Modifies all values by setting the size while centering the rect touching the specified corner.
    public func alignInPlace(size: CGSize, corner e1: CGRectEdge, _ e2: CGRectEdge) -> CGRect {
        return align(size, corner: e1, e2)
    }
}
