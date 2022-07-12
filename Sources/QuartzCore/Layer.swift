import UIKit
import QuartzCore

extension CALayer {
    
    /// 获取图片
    /// - Parameter scale: 比例
    public func toImage(scale: CGFloat = UIScreen.main.scale) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, scale)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /// 获取某一点颜色
    /// - Parameter point: 点
    public func toColor(point: CGPoint) -> UIColor {
        var pixel = [UInt8](repeatElement(0, count: 4))
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(
            data: &pixel,
            width: 1,
            height: 1,
            bitsPerComponent: 8,
            bytesPerRow: 4,
            space: colorSpace,
            bitmapInfo: bitmapInfo.rawValue
        )
        guard let temp = context else {
            return .clear
        }
        
        temp.translateBy(x: -point.x, y: -point.y)
        
        render(in: temp)
        
        let r = pixel[0]
        let g = pixel[1]
        let b = pixel[2]
        let a = pixel[3]
        return UIColor(
            red:    .init(r) / 255.0,
            green:  .init(g) / 255.0,
            blue:   .init(b) / 255.0,
            alpha:  .init(a) / 255.0
        )
    }
}

extension CALayer {
    
    /// 暂停动画
    public func pauseAnimation() {
        //取出当前时间,转成动画暂停的时间
        let pausedTime = convertTime(CACurrentMediaTime(), from: nil)
        //设置动画运行速度为0
        speed = 0.0;
        //设置动画的时间偏移量，指定时间偏移量的目的是让动画定格在该时间点的位置
        timeOffset = pausedTime
    }
    /// 恢复动画
    public func resumeAnimation() {
        //获取暂停的时间差
        let pausedTime = timeOffset
        speed = 1.0
        timeOffset = 0.0
        beginTime = 0.0
        //用现在的时间减去时间差,就是之前暂停的时间,从之前暂停的时间开始动画
        let timeSincePause = convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        beginTime = timeSincePause
    }
}

extension CALayer {
    
    /// 设置阴影 (shadow)
    /// - Parameters:
    ///   - color: 颜色
    ///   - radius: 面积
    ///   - offset: 偏移
    ///   - opacity: 透明度
    public func addShadow(ofColor color: UIColor,
                   radius: CGFloat = 3,
                   offset: CGSize = .zero,
                   opacity: Float = 1) {
        shadowColor = color.cgColor
        shadowOffset = offset
        shadowRadius = radius
        shadowOpacity = opacity
        masksToBounds = false
    }
    
    /// 设置边框 (border)
    /// - Parameters:
    ///   - color: 颜色
    ///   - width: 边宽
    public func addBorder(ofColor color: UIColor, width: CGFloat = 1) {
        borderColor = color.cgColor
        borderWidth = width
    }
}
