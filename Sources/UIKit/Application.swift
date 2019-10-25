import UIKit
import Foundation
import AdSupport

public extension UIApplication {
    
    /// 应用版本号
    static var appVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }
    
    /// 编译版本号
    static var bundleVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
    }
    
    /// 应用名称
    static var appName: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? ""
    }
    
    /// 系统版本
    static var osVersion: String {
        ProcessInfo.processInfo.operatingSystemVersionString
    }
    
    /// 广告标识符
    static var IDFA: String? {
        ASIdentifierManager.shared().isAdvertisingTrackingEnabled ?
            ASIdentifierManager.shared().advertisingIdentifier.uuidString : nil
    }
}
