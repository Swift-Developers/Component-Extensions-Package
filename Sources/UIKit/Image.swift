import UIKit
import CoreImage

extension UIImage {
    
    public func toCGImage() -> CGImage? {
        return cgImage ?? ciImage?.toCGImage()
    }
    
    public func toCIImage() -> CIImage? {
        return ciImage ?? cgImage?.toCIImage()
    }
}

extension CIImage {
    
    public func toCGImage() -> CGImage? {
        return CIContext().createCGImage(self, from: extent)
    }
}

extension CGImage {
    
    public func toCIImage() -> CIImage? {
        return CIImage(cgImage: self)
    }
}

extension UIImage {
    
    public func compressedQuality(_ maxLength: UInt64 = 1024 * 1024) -> UIImage? {
        guard
            var data = jpegData(compressionQuality: 1),
            data.count > maxLength else {
            return self
        }
        
        var max: CGFloat = 1
        var min: CGFloat = 0
        var compression: CGFloat = 1
        for _ in 0 ..< 6 {
            compression = (max + min) / 2
            data = jpegData(compressionQuality: compression) ?? Data()
            
            if CGFloat(data.count) < CGFloat(maxLength) * 0.9 {
                min = compression
            } else if data.count > maxLength {
                max = compression
            } else {
                break
            }
        }
        return UIImage(data: data, scale: scale)
    }
    
    public func compressedSize(_ maxLength: UInt64 = 1024 * 1024) -> UIImage? {
        guard
            var data = jpegData(compressionQuality: 1),
            data.count > maxLength else {
            return self
        }
        
        var result = self
        var lastDataLength = 0
        while data.count > maxLength, data.count != lastDataLength {
            lastDataLength = data.count
            let ratio = CGFloat(maxLength) / CGFloat(data.count)
            let size = CGSize(width: Int(result.size.width * sqrt(ratio)),
                              height: Int(result.size.height * sqrt(ratio)))
            UIGraphicsBeginImageContext(size)
            result.draw(in: CGRect(origin: .zero, size: size))
            result = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            data = result.jpegData(compressionQuality: 1) ?? Data()
        }
        return result
    }
    
    public func compressed(maxLength: UInt64 = 1024 * 1024) -> UIImage? {
        guard let image = compressedQuality(maxLength) else {
            return self
        }
        guard let result = image.compressedSize(maxLength) else {
            return self
        }
        return result
    }
}
