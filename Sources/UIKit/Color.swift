import UIKit

extension UIColor {
    
    /// 转换到另一个颜色
    /// - Parameter color: 目标颜色
    /// - Parameter progress: 转换进度 0 - 1
    func transition(to color: UIColor, progress: CGFloat) -> UIColor {
        
        let progress = min(progress, 1.0)
        
        let r = redValue + (color.redValue - redValue) * progress
        let g = greenValue + (color.greenValue - greenValue) * progress
        let b = blueValue + (color.blueValue - blueValue) * progress
        let a = alphaValue + (color.alphaValue - alphaValue) * progress
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    /// 红色值 0 - 1
    var redValue: CGFloat {
        var r: CGFloat = 0
        if getRed(&r, green: nil, blue: nil, alpha: nil) {
            return r
        }
        return 0
    }
    
    /// 绿色值 0 - 1
    var greenValue: CGFloat {
        var g: CGFloat = 0
        if getRed(nil, green: &g, blue: nil, alpha: nil) {
            return g
        }
        return 0
    }
    
    /// 蓝色值 0 - 1
    var blueValue: CGFloat {
        var b: CGFloat = 0
        if getRed(nil, green: nil, blue: &b, alpha: nil) {
            return b
        }
        return 0
    }
    
    /// 透明值 0 - 1
    var alphaValue: CGFloat {
        var a: CGFloat = 0
        if getRed(nil, green: nil, blue: nil, alpha: &a) {
            return a
        }
        return 0
    }
}
