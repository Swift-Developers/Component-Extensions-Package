import Foundation

extension Date {
    
    /// 上午/下午
    public var ampm: String {
        let formatter = DateFormatter()
        formatter.amSymbol = "上午"
        formatter.pmSymbol = "下午"
        formatter.dateFormat = "aaa"
        return formatter.string(from: self)
    }
    
    public func timePassed() -> String {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: self,
            to: date
        )
        
        if let year = components.year, year >= 1 {
            return "\(year)年前"
        } else if let month = components.month, month >= 1 {
            return "\(month)月前"
        } else if let day = components.day, day >= 1 {
            return "\(day)天前"
        } else if let hour = components.hour, hour >= 1 {
            return "\(hour)小时前"
        } else if let minute = components.minute, minute >= 1 {
            return "\(minute)分钟前"
        } else if let second = components.second, second >= 1 {
            return "\(second)秒前"
        } else {
            return "刚刚"
        }
    }
}

extension Date {
    
    public func format(_ string: String = "yyyy-MM-dd HH:mm:ss", locale: Locale = .current) -> String {
        Date.formatter.locale = locale
        Date.formatter.dateFormat = string
        return Date.formatter.string(from: self)
    }
    
    private static let formatter = DateFormatter()
}

extension Date {
    
    /// 星座
    public var constellation: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd"
        dateFormatter.string(from: self)
        let double = Double(dateFormatter.string(from: self)) ?? .greatestFiniteMagnitude
        switch double.rounded(numberOfDecimalPlaces: 2, rule: .up) {
        case 1.20...2.18 :      return "水瓶座"
        case 2.19...3.20 :      return "双鱼座"
        case 3.21...4.19 :      return "白羊座"
        case 4.20...5.20 :      return "金牛座"
        case 5.21...6.21 :      return "双子座"
        case 6.22...7.22 :      return "巨蟹座"
        case 7.23...8.22 :      return "狮子座"
        case 8.23...9.22 :      return "处女座"
        case 9.23...10.23 :     return "天秤座"
        case 10.24...11.22 :    return "天蝎座"
        case 11.23...12.21 :    return "射手座"
        case 12.22...12.31 :    return "摩羯座"
        case 1.01...1.19 :      return "摩羯座"
        default:                return nil
        }
    }
}


fileprivate extension BinaryFloatingPoint {
    
    func rounded(numberOfDecimalPlaces: Int, rule: FloatingPointRoundingRule) -> Self {
        let factor = Self(pow(10.0, Double(max(0, numberOfDecimalPlaces))))
        return (self * factor).rounded(rule) / factor
    }
}
