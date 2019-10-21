import QuartzCore

/// 3D透视
/// - Parameter center: 相机位置
/// - Parameter disZ: 深度 (相机与平面距离)
public func CATransform3DMakePerspective(_ center: CGPoint, _ disZ: CGFloat) -> CATransform3D {
    let transToCenter = CATransform3DMakeTranslation(-center.x, -center.y, 0)
    let transBack = CATransform3DMakeTranslation(center.x, center.y, 0)
    var scale = CATransform3DIdentity
    scale.m34 = -1.0 / disZ
    return CATransform3DConcat(CATransform3DConcat(transToCenter, scale), transBack)
}

/// 3D透视
/// - Parameter t: 连接矩阵
/// - Parameter center: 相机位置
/// - Parameter disZ: 深度 (相机与平面距离)
public func CATransform3DPerspect(_ t: CATransform3D, center: CGPoint, disZ: CGFloat) -> CATransform3D {
    return CATransform3DConcat(t, CATransform3DMakePerspective(center, disZ))
}
