import UIKit

public protocol UIAccuracyCalibrationable {
    
    /// 精度修复计算
    ///
    /// - Returns: 结果
    func precision() -> Self
}

extension Double: UIAccuracyCalibrationable {
    
    public func precision() -> Double {
        self * Double(UIScreen.main.scale).rounded(.up) / Double(UIScreen.main.scale)
    }
}

extension BinaryInteger {
    
    public func precision() -> Double {
        let temp = Double("\(self)") ?? 0
        return temp.precision()
    }
    
    public func precision<T>() -> T where T : BinaryInteger {
        let temp = Double("\(self)") ?? 0
        return T(temp.precision())
    }
    
    public func precision<T>() -> T where T : BinaryFloatingPoint {
        let temp = Double("\(self)") ?? 0
        return T(temp.precision())
    }
}

extension BinaryFloatingPoint {
    
    public func precision() -> Double {
        let temp = Double("\(self)") ?? 0
        return temp.precision()
    }
    public func zoom<T>() -> T where T : BinaryInteger {
        let temp = Double("\(self)") ?? 0
        return T(temp.precision())
    }
    public func precision<T>() -> T where T : BinaryFloatingPoint {
        let temp = Double("\(self)") ?? 0
        return T(temp.precision())
    }
}

extension CGPoint: UIAccuracyCalibrationable {
    
    public func precision() -> CGPoint {
        return CGPoint(x: x.precision(), y: y.precision())
    }
}

extension CGSize: UIAccuracyCalibrationable {
    
    public func precision() -> CGSize {
        return CGSize(width: width.zoom(), height: height.zoom())
    }
}

extension CGRect: UIAccuracyCalibrationable {
    
    public func precision() -> CGRect {
        return CGRect(origin: origin.precision(), size: size.precision())
    }
}

extension CGVector: UIAccuracyCalibrationable {
    
    public func precision() -> CGVector {
        return CGVector(dx: dx.precision(), dy: dy.precision())
    }
}

extension UIOffset: UIAccuracyCalibrationable {
    
    public func precision() -> UIOffset {
        return UIOffset(horizontal: horizontal.precision(), vertical: vertical.precision())
    }
}

extension UIEdgeInsets: UIAccuracyCalibrationable {
    
    public func precision() -> UIEdgeInsets {
        return UIEdgeInsets(
            top: top.precision(),
            left: left.precision(),
            bottom: bottom.precision(),
            right: right.precision()
        )
    }
}

