import UIKit
import Extensions_Foundation

extension UIView {
    
    public static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    public static func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)?.first as! T
    }
}

extension UIView {
    
    private static var cornerRadiiKey: Void?
    
    private class Wrapper<T> {
        let value: T?
        init(_ value: T?) {
            self.value = value
        }
    }
    
    public var cornerRadii: CornerRadii? {
        get {
            let wrapper: Wrapper<CornerRadii>? = associated.get(&UIView.cornerRadiiKey)
            return wrapper?.value
        }
        set {
            let wrapper = Wrapper(newValue)
            associated.set(retain: &UIView.cornerRadiiKey, wrapper)
            
            if let value = newValue {
                update(value)
                
            } else {
                layer.mask = nil
            }
            
            UIView.swizzled
        }
    }
    
    private static let swizzled: Void = {
        let originalSelector = #selector(UIView.layoutSubviews)
        let swizzledSelector = #selector(UIView._layoutSubviews)
        
        guard
            let originalMethod = class_getInstanceMethod(UIView.self, originalSelector),
            let swizzledMethod = class_getInstanceMethod(UIView.self, swizzledSelector) else {
            return
        }
        
        // 在进行 Swizzling 的时候,需要用 class_addMethod 先进行判断一下原有类中是否有要替换方法的实现
        let didAddMethod: Bool = class_addMethod(
            UIView.self,
            originalSelector,
            method_getImplementation(swizzledMethod),
            method_getTypeEncoding(swizzledMethod)
        )
        // 如果 class_addMethod 返回 yes,说明当前类中没有要替换方法的实现,所以需要在父类中查找,这时候就用到 method_getImplemetation 去获取 class_getInstanceMethod 里面的方法实现,然后再进行 class_replaceMethod 来实现 Swizzing
        if didAddMethod {
            class_replaceMethod(
                UIView.self,
                swizzledSelector,
                method_getImplementation(originalMethod),
                method_getTypeEncoding(originalMethod)
            )
            
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    } ()
    
    @objc
    private func _layoutSubviews() {
        _layoutSubviews()
        update(cornerRadii)
    }
    
    private func update(_ cornerRadii: CornerRadii?) {
        guard let cornerRadii = cornerRadii else {
            return
        }
        
        let lastShapeLayer = layer.mask as? CAShapeLayer
        let lastPath = lastShapeLayer?.path
        let path = CornerRadii.path(bounds, cornerRadii)
        // 防止相同路径多次设置
        guard lastPath != path else { return }
        // 移除原有路径动画
        lastShapeLayer?.removeAnimation(forKey: "cornerradii.path")
        // 重置新路径mask
        let mask = CAShapeLayer()
        mask.path = path
        layer.mask = mask
        // 同步视图大小变更动画
        if let temp = layer.animation(forKey: "bounds.size") {
            let animation = CABasicAnimation(keyPath: "path")
            animation.duration = temp.duration
            animation.fillMode = temp.fillMode
            animation.timingFunction = temp.timingFunction
            animation.fromValue = lastPath
            animation.toValue = path
            mask.add(animation, forKey: "cornerradii.path")
        }
    }
    
    public struct CornerRadii: Equatable {
        public var topLeft: CGFloat
        public var topRight: CGFloat
        public var bottomLeft: CGFloat
        public var bottomRight: CGFloat
        
        public init(topLeft: CGFloat = 0, topRight: CGFloat = 0, bottomLeft: CGFloat = 0, bottomRight: CGFloat = 0) {
            self.topLeft = topLeft
            self.topRight = topRight
            self.bottomLeft = bottomLeft
            self.bottomRight = bottomRight
        }
        
        public func with(topLeft: CGFloat) -> CornerRadii {
            var temp = self
            temp.topLeft = topLeft
            return temp
        }
        
        public func with(topRight: CGFloat) -> CornerRadii {
            var temp = self
            temp.topRight = topRight
            return temp
        }
        
        public func with(bottomLeft: CGFloat) -> CornerRadii {
            var temp = self
            temp.bottomLeft = bottomLeft
            return temp
        }
        
        public func with(bottomRight: CGFloat) -> CornerRadii {
            var temp = self
            temp.bottomRight = bottomRight
            return temp
        }
        
        public static let zero: CornerRadii = .init(topLeft: 0, topRight: 0, bottomLeft: 0, bottomRight: 0)
        
        static func path(_ bounds: CGRect, _ radii: CornerRadii) -> CGPath {
            let minX = bounds.minX
            let minY = bounds.minY
            let maxX = bounds.maxX
            let maxY = bounds.maxY
            
            let topLeftCenter: CGPoint = .init(minX + radii.topLeft, minY + radii.topLeft)
            let topRightCenter: CGPoint = .init(maxX - radii.topRight, minY + radii.topRight)
            let bottomLeftCenter: CGPoint = .init(minX + radii.bottomLeft, maxY - radii.bottomLeft)
            let bottomRightCenter: CGPoint = .init(maxX - radii.bottomRight, maxY - radii.bottomRight)
            
            let path = CGMutablePath()
            path.addArc(
                center: topLeftCenter,
                radius: radii.topLeft,
                startAngle: .pi,
                endAngle: .pi / 2 * 3,
                clockwise: false
            )
            path.addArc(
                center: topRightCenter,
                radius: radii.topRight,
                startAngle: .pi / 2 * 3,
                endAngle: 0,
                clockwise: false
            )
            path.addArc(
                center: bottomRightCenter,
                radius: radii.bottomRight,
                startAngle: 0,
                endAngle: .pi / 2,
                clockwise: false
            )
            path.addArc(
                center: bottomLeftCenter,
                radius: radii.bottomLeft,
                startAngle: .pi / 2,
                endAngle: .pi,
                clockwise: false
            )
            path.closeSubpath()
            return path
        }
    }
}

public extension UIView {
    
    var snapshotPDF: Data? {
        let datas = NSMutableData()
        UIGraphicsBeginPDFContextToData(datas, bounds, nil)
        defer { UIGraphicsEndPDFContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.beginPDFPage(nil)
        context.translateBy(x: 0, y: bounds.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        layer.render(in: context)
        context.endPDFPage()
        context.closePDF()
        return datas as Data
    }
}
