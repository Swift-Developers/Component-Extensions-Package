import Foundation

extension TimeInterval {
    
    public enum DateType {
        case since1970
        case sinceNow
        case since(Date)
    }
    
    public func toDate(_ type: DateType = .since1970) -> Date {
        switch type {
        case .since1970:        return .init(timeIntervalSince1970: self)
        case .sinceNow:         return .init(timeIntervalSinceNow: self)
        case .since(let date):  return .init(timeInterval: self, since: date)
        }
    }
}
