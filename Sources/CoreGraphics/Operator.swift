import CoreGraphics

/// Returns a point by adding the coordinates of another point.
public func + (p1: CGPoint, p2: CGPoint) -> CGPoint {
    return .init(x: p1.x + p2.x, y: p1.y + p2.y)
}
/// Modifies the x and y values by adding the coordinates of another point.
public func += (p1: inout CGPoint, p2: CGPoint) {
    p1.x += p2.x
    p1.y += p2.y
}
/// Returns a point by subtracting the coordinates of another point.
public func - (p1: CGPoint, p2: CGPoint) -> CGPoint {
    return .init(x: p1.x - p2.x, y: p1.y - p2.y)
}
/// Modifies the x and y values by subtracting the coordinates of another points.
public func -= (p1: inout CGPoint, p2: CGPoint) {
    p1.x -= p2.x
    p1.y -= p2.y
}

/// Returns a point by adding a size to the coordinates.
public func + (point: CGPoint, size: CGSize) -> CGPoint {
    return .init(x: point.x + size.width, y: point.y + size.height)
}
/// Modifies the x and y values by adding a size to the coordinates.
public func += (point: inout CGPoint, size: CGSize) {
    point.x += size.width
    point.y += size.height
}
/// Returns a point by subtracting a size from the coordinates.
public func - (point: CGPoint, size: CGSize) -> CGPoint {
    return .init(x: point.x - size.width, y: point.y - size.height)
}
/// Modifies the x and y values by subtracting a size from the coordinates.
public func -= (point: inout CGPoint, size: CGSize) {
    point.x -= size.width
    point.y -= size.height
}

/// Returns a point by adding a tuple to the coordinates.
public func + (point: CGPoint, tuple: (CGFloat, CGFloat)) -> CGPoint {
    return .init(x: point.x + tuple.0, y: point.y + tuple.1)
}
/// Modifies the x and y values by adding a tuple to the coordinates.
public func += (point: inout CGPoint, tuple: (CGFloat, CGFloat)) {
    point.x += tuple.0
    point.y += tuple.1
}
/// Returns a point by subtracting a tuple from the coordinates.
public func - (point: CGPoint, tuple: (CGFloat, CGFloat)) -> CGPoint {
    return .init(x: point.x - tuple.0, y: point.y - tuple.1)
}
/// Modifies the x and y values by subtracting a tuple from the coordinates.
public func -= (point: inout CGPoint, tuple: (CGFloat, CGFloat)) {
    point.x -= tuple.0
    point.y -= tuple.1
}
/// Returns a point by multiplying the coordinates with a value.
public func * (point: CGPoint, factor: CGFloat) -> CGPoint {
    return .init(x: point.x * factor, y: point.y * factor)
}
/// Modifies the x and y values by multiplying the coordinates with a value.
public func *= (point: inout CGPoint, factor: CGFloat) {
    point.x *= factor
    point.y *= factor
}
/// Returns a point by multiplying the coordinates with a tuple.
public func * (point: CGPoint, tuple: (CGFloat, CGFloat)) -> CGPoint {
    return .init(x: point.x * tuple.0, y: point.y * tuple.1)
}
/// Modifies the x and y values by multiplying the coordinates with a tuple.
public func *= (point: inout CGPoint, tuple: (CGFloat, CGFloat)) {
    point.x *= tuple.0
    point.y *= tuple.1
}
/// Returns a point by dividing the coordinates by a tuple.
public func / (point: CGPoint, tuple: (CGFloat, CGFloat)) -> CGPoint {
    return .init(x: point.x / tuple.0, y: point.y / tuple.1)
}
/// Modifies the x and y values by dividing the coordinates by a tuple.
public func /= (point: inout CGPoint, tuple: (CGFloat, CGFloat)) {
    point.x /= tuple.0
    point.y /= tuple.1
}
/// Returns a point by dividing the coordinates by a factor.
public func / (point: CGPoint, factor: CGFloat) -> CGPoint {
    return .init(x: point.x / factor, y: point.y / factor)
}
/// Modifies the x and y values by dividing the coordinates by a factor.
public func /= (point: inout CGPoint, factor: CGFloat) {
    point.x /= factor
    point.y /= factor
}

/// Returns a point by adding another size.
public func + (s1: CGSize, s2: CGSize) -> CGSize {
    return .init(width: s1.width + s2.width, height: s1.height + s2.height)
}
/// Modifies the width and height values by adding another size.
public func += (s1: inout CGSize, s2: CGSize) {
    s1.width += s2.width
    s1.height += s2.height
}
/// Returns a point by subtracting another size.
public func - (s1: CGSize, s2: CGSize) -> CGSize {
    return CGSize(width: s1.width - s2.width, height: s1.height - s2.height)
}
/// Modifies the width and height values by subtracting another size.
public func -= (s1: inout CGSize, s2: CGSize) {
    s1.width -= s2.width
    s1.height -= s2.height
}

/// Returns a point by adding a tuple.
public func + (size: CGSize, tuple: (CGFloat, CGFloat)) -> CGSize {
    return CGSize(width: size.width + tuple.0, height: size.height + tuple.1)
}
/// Modifies the width and height values by adding a tuple.
public func += (size: inout CGSize, tuple: (CGFloat, CGFloat)) {
    size.width += tuple.0
    size.height += tuple.1
}
/// Returns a point by subtracting a tuple.
public func - (size: CGSize, tuple: (CGFloat, CGFloat)) -> CGSize {
    return .init(width: size.width - tuple.0, height: size.height - tuple.1)
}
/// Modifies the width and height values by subtracting a tuple.
public func -= (size: inout CGSize, tuple: (CGFloat, CGFloat)) {
    size.width -= tuple.0
    size.height -= tuple.1
}
/// Returns a point by multiplying the size with a factor.
public func * (size: CGSize, factor: CGFloat) -> CGSize {
    return .init(width: size.width * factor, height: size.height * factor)
}
/// Modifies the width and height values by multiplying them with a factor.
public func *= (size: inout CGSize, factor: CGFloat) {
    size.width *= factor
    size.height *= factor
}
/// Returns a point by multiplying the size with a tuple.
public func * (size: CGSize, tuple: (CGFloat, CGFloat)) -> CGSize {
    return .init(width: size.width * tuple.0, height: size.height * tuple.1)
}
/// Modifies the width and height values by multiplying them with a tuple.
public func *= (size: inout CGSize, tuple: (CGFloat, CGFloat)) {
    size.width *= tuple.0
    size.height *= tuple.1
}
/// Returns a point by dividing the size by a factor.
public func / (size: CGSize, factor: CGFloat) -> CGSize {
    return .init(width: size.width / factor, height: size.height / factor)
}
/// Modifies the width and height values by dividing them by a factor.
public func /= (size: inout CGSize, factor: CGFloat) {
    size.width /= factor
    size.height /= factor
}
/// Returns a point by dividing the size by a tuple.
public func / (size: CGSize, tuple: (CGFloat, CGFloat)) -> CGSize {
    return .init(width: size.width / tuple.0, height: size.height / tuple.1)
}
/// Modifies the width and height values by dividing them by a tuple.
public func /= (size: inout CGSize, tuple: (CGFloat, CGFloat)) {
    size.width /= tuple.0
    size.height /= tuple.1
}

/// Returns a rect by adding the coordinates of a point to the origin.
public func + (rect: CGRect, point: CGPoint) -> CGRect {
    return .init(origin: rect.origin + point, size: rect.size)
}
/// Modifies the x and y values by adding the coordinates of a point.
public func += (rect: inout CGRect, point: CGPoint) {
    rect.origin += point
}
/// Returns a rect by subtracting the coordinates of a point from the origin.
public func - (rect: CGRect, point: CGPoint) -> CGRect {
    return .init(origin: rect.origin - point, size: rect.size)
}
/// Modifies the x and y values by subtracting the coordinates from a point.
public func -= (rect: inout CGRect, point: CGPoint) {
    rect.origin -= point
}

/// Returns a rect by adding a size to the size.
public func + (rect: CGRect, size: CGSize) -> CGRect {
    return .init(origin: rect.origin, size: rect.size + size)
}
/// Modifies the width and height values by adding a size.
public func += (rect: inout CGRect, size: CGSize) {
    rect.size += size
}
/// Returns a rect by subtracting a size from the size.
public func - (rect: CGRect, size: CGSize) -> CGRect {
    return .init(origin: rect.origin, size: rect.size - size)
}
/// Modifies the width and height values by subtracting a size.
public func -= (rect: inout CGRect, size: CGSize) {
    rect.size -= size
}

/// Returns a point by applying a transform.
public func * (point: CGPoint, transform: CGAffineTransform) -> CGPoint {
    return point.applying(transform)
}
/// Modifies all values by applying a transform.
public func *= (point: inout CGPoint, transform: CGAffineTransform) {
    point = point.applying(transform)
}
/// Returns a size by applying a transform.
public func * (size: CGSize, transform: CGAffineTransform) -> CGSize {
    return size.applying(transform)
}
/// Modifies all values by applying a transform.
public func *= (size: inout CGSize, transform: CGAffineTransform) {
    size = size.applying(transform)
}
/// Returns a rect by applying a transform.
public func * (rect: CGRect, transform: CGAffineTransform) -> CGRect {
    return rect.applying(transform)
}
/// Modifies all values by applying a transform.
public func *= (rect: inout CGRect, transform: CGAffineTransform) {
    rect = rect.applying(transform)
}

/// Returns a transform by concatenating two transforms.
public func * (t1: CGAffineTransform, t2: CGAffineTransform) -> CGAffineTransform {
    return t1.concatenating(t2)
}
/// Modifies all values by concatenating another transform.
public func *= (t1: inout CGAffineTransform, t2: CGAffineTransform) {
    t1 = t1.concatenating(t2)
}
