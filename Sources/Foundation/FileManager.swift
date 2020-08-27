import Foundation

extension FileManager {
    
    /// 获取文件大小
    /// - Parameter path: 路径
    /// - Returns: Bytes
    public func fileSize(at path: String) -> Int64? {
        var isDirectory: ObjCBool = false
        guard fileExists(atPath: path, isDirectory: &isDirectory) else {
            return nil
        }
        
        if isDirectory.boolValue {
            return subpaths(atPath: path)?.reduce(into: 0) {
                $0 += (fileSize(at: path + "/" + $1) ?? 0)
            }
            
        } else {
            let attributes = try? attributesOfItem(atPath: path)
            return attributes?[.size] as? Int64
        }
    }
}
