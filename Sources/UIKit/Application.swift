import UIKit
import Foundation

extension UIApplication {
    
    /// 应用版本号
    public static var appVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }
    
    /// 编译版本号
    public static var bundleVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
    }
    
    /// 应用名称
    public static var appName: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? ""
    }
    
    /// 系统版本
    public static var osVersion: String {
        ProcessInfo.processInfo.operatingSystemVersionString
    }
}

extension UIApplication {
    
    public var window: UIWindow? {
        if #available(iOS 13.0, *) {
            let windows: [UIWindow] = UIApplication.shared.connectedScenes.compactMap { scene in
                guard let scene = scene as? UIWindowScene else { return nil }
                guard scene.session.role == .windowApplication else { return nil }
                guard let delegate = scene.delegate as? UIWindowSceneDelegate else { return nil }
                guard let window = delegate.window else { return nil }
                guard let window = window else { return nil }
                return window
            }
            
            if windows.isEmpty {
                guard let delegate = UIApplication.shared.delegate else { return nil }
                guard let window = delegate.window else { return nil }
                return window
                
            } else {
                return windows.first
            }
            
        } else {
            guard let delegate = UIApplication.shared.delegate else { return nil }
            guard let window = delegate.window else { return nil }
            return window
        }
    }
    
    public static var statusBarSize: CGSize {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.window?.windowScene?.statusBarManager?.statusBarFrame.size ?? UIApplication.shared.statusBarFrame.size
            
        } else {
            return UIApplication.shared.statusBarFrame.size
        }
    }
}
