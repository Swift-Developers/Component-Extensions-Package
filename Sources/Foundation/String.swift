import Foundation

extension String {
    
    /// 转换为富文本
    /// - Parameter attributes: 属性
    public func attributed(_ attributes: [NSAttributedString.Key: Any] = [:]) -> NSAttributedString {
        return .init(string: self, attributes: attributes)
    }
}

extension String {
    
    /// 转为Date
    /// - Parameter format: 格式
    /// - Parameter locale: 本地化
    public func date(_ format: String = "yyyy-MM-dd HH:mm:ss.0", locale: Locale = .current) -> Date? {
        String.formatter.locale = locale
        String.formatter.dateFormat = format
        return String.formatter.date(from: self)
    }
    
    private static let formatter = DateFormatter()
}

extension String {
    public static let attachmentCharacter: String = "\u{FFFC}"
    
    // used for NSString related task. since .count is not always equal to .length for emojis etc..
    public var length: Int {
        utf16.count
    }
    
    public var nilIfEmpty: String? {
        isEmpty ? nil : self
    }
    
    public var pathComponents: [String] {
        (self as NSString).pathComponents
    }
    
    public var numberOfWords: Int {
        var count = 0
        enumerateSubstrings(in: startIndex..<endIndex, options: [.byWords, .substringNotRequired, .localized]) {
            _, _, _, _ -> Void in
            count += 1
        }
        return count
    }
}

extension NSString {
    public var numberOfWords: Int {
        let inputRange = CFRangeMake(0, length)
        let flag = UInt(kCFStringTokenizerUnitWord)
        let locale = CFLocaleCopyCurrent()
        let tokenizer = CFStringTokenizerCreate(kCFAllocatorDefault, self, inputRange, flag, locale)
        var tokenType = CFStringTokenizerAdvanceToNextToken(tokenizer)
        var count = 0
        
        while tokenType != [] {
            count += 1
            tokenType = CFStringTokenizerAdvanceToNextToken(tokenizer)
        }
        return count
    }
}
