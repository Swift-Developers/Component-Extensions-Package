import UIKit
import AdSupport

public extension UIApplication {
    
    static var appVersion: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }
    
    static var bundleVersion: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
    }
    
    static var appName: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? ""
    }
    
    static var osVersion: String {
        return ProcessInfo.processInfo.operatingSystemVersionString
    }
    
    static var IDFA: String? {
        return ASIdentifierManager.shared().isAdvertisingTrackingEnabled ?
            ASIdentifierManager.shared().advertisingIdentifier.uuidString : nil
    }
}
