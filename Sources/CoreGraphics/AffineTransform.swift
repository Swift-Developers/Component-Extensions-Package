import CoreGraphics

extension CGAffineTransform: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return "(\(a),\(b),\(c),\(d),\(tx),\(ty))"
    }
}
