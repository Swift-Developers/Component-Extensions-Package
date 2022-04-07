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

extension UIView {
    private struct AssociateKey {
        static var borderColor: Void?
        static var shadowColor: Void?
        static var hitTestSlop: Void?
    }
    
    open var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    open var zPosition: CGFloat {
        get { layer.zPosition }
        set { layer.zPosition = newValue }
    }
    
    open var borderWidth: CGFloat {
        get { layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    open var shadowOpacity: CGFloat {
        get { CGFloat(layer.shadowOpacity) }
        set { layer.shadowOpacity = Float(newValue) }
    }
    
    open var shadowRadius: CGFloat {
        get { layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }
    
    open var shadowOffset: CGSize {
        get { layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }
    
    open var shadowPath: UIBezierPath? {
        get { layer.shadowPath.map { UIBezierPath(cgPath: $0) } }
        set { layer.shadowPath = newValue?.cgPath }
    }
    
    open var hitTestSlop: UIEdgeInsets {
        get {
            (objc_getAssociatedObject(self, &AssociateKey.hitTestSlop) as? NSValue)?.uiEdgeInsetsValue ?? .zero
        }
        set {
            _ = UIView.swizzlePointInside
            objc_setAssociatedObject(self, &AssociateKey.hitTestSlop, NSValue(uiEdgeInsets: newValue), .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    open var borderColor: UIColor? {
        get {
            if #available(iOS 13.0, *) {
                return objc_getAssociatedObject(self, &AssociateKey.borderColor) as? UIColor
            } else {
                guard let color = layer.borderColor else { return nil }
                return UIColor(cgColor: color)
            }
            
        }
        set {
            if #available(iOS 13.0, *) {
                _ = UIView.swizzleTraitCollection
                objc_setAssociatedObject(self, &AssociateKey.borderColor, newValue, .OBJC_ASSOCIATION_RETAIN)
                layer.borderColor = borderColor?.resolvedColor(with: traitCollection).cgColor
            } else {
                layer.borderColor = newValue?.cgColor
            }
        }
    }
    
    open var shadowColor: UIColor? {
        get {
            if #available(iOS 13.0, *) {
                return objc_getAssociatedObject(self, &AssociateKey.shadowColor) as? UIColor
            } else {
                guard let color = layer.shadowColor else { return nil }
                return UIColor(cgColor: color)
            }
        }
        set {
            if #available(iOS 13.0, *) {
                _ = UIView.swizzleTraitCollection
                objc_setAssociatedObject(self, &AssociateKey.shadowColor, newValue, .OBJC_ASSOCIATION_RETAIN)
                layer.shadowColor = shadowColor?.resolvedColor(with: traitCollection).cgColor
            } else {
                layer.shadowColor = newValue?.cgColor
            }
        }
    }
    
    open var frameWithoutTransform: CGRect {
        get {
            CGRect(center: center, size: bounds.size)
        }
        set {
            bounds.size = newValue.size
            center = newValue.offsetBy(
                dx: bounds.width * (layer.anchorPoint.x - 0.5),
                dy: bounds.height * (layer.anchorPoint.y - 0.5)
            ).center
        }
    }
    
    open var firstResponder: UIView? {
        if isFirstResponder {
            return self
        }
        for subview in subviews {
            if let firstResponder = subview.firstResponder {
                return firstResponder
            }
        }
        return nil
    }
    
    open class var isInAnimationBlock: Bool {
        UIView.perform(NSSelectorFromString("_isInAnimationBlock")) != nil
    }
    
    private static let swizzlePointInside: Void = {
        guard let originalMethod = class_getInstanceMethod(UIView.self, #selector(point(inside:with:))),
              let swizzledMethod = class_getInstanceMethod(UIView.self, #selector(swizzled_point(inside:with:)))
        else { return }
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }()
    
    @available(iOS 13.0, *)
    private static let swizzleTraitCollection: Void = {
        guard let originalMethod = class_getInstanceMethod(UIView.self, #selector(traitCollectionDidChange(_:))),
              let swizzledMethod = class_getInstanceMethod(UIView.self, #selector(swizzled_traitCollectionDidChange(_:)))
        else { return }
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }()
    
    @available(iOS 13.0, *)
    @objc func swizzled_traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        swizzled_traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            if let borderColor = borderColor {
                layer.borderColor = borderColor.resolvedColor(with: traitCollection).cgColor
            }
            if let shadowColor = shadowColor {
                layer.shadowColor = shadowColor.resolvedColor(with: traitCollection).cgColor
            }
        }
    }
    
    @objc func swizzled_point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        bounds.inset(by: hitTestSlop).contains(point)
    }
}

extension UIView {
    public func superview<T: UIView>(matchingType _: T.Type) -> T? {
        var current: UIView? = self
        while let next = current?.superview {
            if let next = next as? T {
                return next
            }
            current = next
        }
        return nil
    }
    
    public func findSubview<ViewType: UIView>(checker: ((ViewType) -> Bool)? = nil) -> ViewType? {
        for subview in [self] + flattendSubviews.reversed() {
            if let subview = subview as? ViewType, checker?(subview) != false {
                return subview
            }
        }
        return nil
    }
    
    public func contains(view: UIView) -> Bool {
        if view == self {
            return true
        }
        return subviews.contains(where: { $0.contains(view: view) })
    }
}

extension UIView {
    open var parentViewController: UIViewController? {
        var responder: UIResponder? = self
        while responder is UIView {
            responder = responder!.next
        }
        return responder as? UIViewController
    }
    
    open var presentedViewController: UIViewController? {
        parentViewController?.presentedViewController
    }
    
    open var presentingViewController: UIViewController? {
        parentViewController?.presentingViewController
    }
    
    open func present(_ viewController: UIViewController, completion: (() -> Void)? = nil) {
        parentViewController?.present(viewController, animated: true, completion: completion)
    }
    
    open func push(_ viewController: UIViewController) {
        parentViewController?.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc open func dismiss(completion: (() -> Void)? = nil) {
        guard let viewController = parentViewController else {
            return
        }
        if let navVC = viewController.navigationController, navVC.viewControllers.count > 1 {
            navVC.popViewController(animated: true)
            completion?()
        } else {
            viewController.dismiss(animated: true, completion: completion)
        }
    }
    
    @objc open func dismissModal(completion: (() -> Void)? = nil) {
        guard let viewController = parentViewController else {
            return
        }
        viewController.dismiss(animated: true, completion: completion)
    }
}

extension UIView {
    /// Create image snapshot of view.
    ///
    /// - Parameters:
    ///   - rect: The coordinates (in the view's own coordinate space) to be captured. If omitted, the entire `bounds` will be captured.
    ///   - afterScreenUpdates: A Boolean value that indicates whether the snapshot should be rendered after recent changes have been incorporated. Specify the value false if you want to render a snapshot in the view hierarchy’s current state, which might not include recent changes. Defaults to `true`.
    ///
    /// - Returns: The `UIImage` snapshot.
    
    public func snapshot(of rect: CGRect? = nil, afterScreenUpdates: Bool = true) -> UIImage {
        UIGraphicsImageRenderer(bounds: rect ?? bounds).image { _ in
            drawHierarchy(in: bounds, afterScreenUpdates: afterScreenUpdates)
        }
    }
    
    public var flattendSubviews: [UIView] {
        subviews + subviews.flatMap { $0.flattendSubviews }
    }
    
    public func closestViewMatchingType<ViewType: UIView>(_: ViewType.Type) -> ViewType? {
        closestViewPassingTest {
            $0 is ViewType
        } as? ViewType
    }
    
    public func closestViewPassingTest(_ test: (UIView) -> Bool) -> UIView? {
        var current: UIView? = self.superview
        while current != nil {
            if test(current!) {
                return current
            }
            current = current?.superview
        }
        return nil
    }
}
