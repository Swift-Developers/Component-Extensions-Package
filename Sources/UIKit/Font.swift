import UIKit

extension UIFont {
    
    /// 等宽字体  该方法仅对系统字体有效
    ///
    /// - Returns: 等宽字体
    public var systemMonospaced: UIFont {
        guard familyName == UIFont.systemFont(ofSize: 1).familyName else {
            return self
        }
        
        let setting: [UIFontDescriptor.FeatureKey: Any]
        if #available(iOS 15.0, *) {
            setting = [
                UIFontDescriptor.FeatureKey.type: kNumberSpacingType,
                UIFontDescriptor.FeatureKey.selector: kMonospacedNumbersSelector
            ]
            
        } else {
            setting = [
                UIFontDescriptor.FeatureKey.featureIdentifier: kNumberSpacingType,
                UIFontDescriptor.FeatureKey.typeIdentifier: kMonospacedNumbersSelector
            ]
        }
        let new = fontDescriptor.addingAttributes([.featureSettings: [setting]])
        return UIFont(descriptor: new, size: 0)
    }
}

extension UIFont {
    
    public static func regular(size: CGFloat) -> UIFont {
        let name = "PingFangSC-Regular"
        return UIFont(name: name, size: size) ?? .system(size, .regular)
    }
    public static func semibold(size: CGFloat) -> UIFont {
        let name = "PingFangSC-Semibold"
        return UIFont(name: name, size: size) ?? .system(size, .semibold)
    }
    public static func light(size: CGFloat) -> UIFont {
        let name = "PingFangSC-Light"
        return UIFont(name: name, size: size) ?? .system(size, .light)
    }
    public static func medium(size: CGFloat) -> UIFont {
        let name = "PingFangSC-Medium"
        return UIFont(name: name, size: size) ?? .system(size, .medium)
    }
    private static func system(_ size: CGFloat, _ weight: UIFont.Weight) -> UIFont {
        return .systemFont(ofSize: size, weight: weight)
    }
}
