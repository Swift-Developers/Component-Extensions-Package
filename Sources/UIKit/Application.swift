import UIKit
import Foundation
import AdSupport

public extension UIApplication {
    
    static var appVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }
    
    static var bundleVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
    }
    
    static var appName: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? ""
    }
    
    static var osVersion: String {
        ProcessInfo.processInfo.operatingSystemVersionString
    }
    
    static var IDFA: String? {
        ASIdentifierManager.shared().isAdvertisingTrackingEnabled ?
            ASIdentifierManager.shared().advertisingIdentifier.uuidString : nil
    }
}
