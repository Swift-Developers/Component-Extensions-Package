import UIKit
import CoreImage
import Accelerate

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
    
    /// 根据质量压缩
    /// - Parameter maxLength: 最大字节
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
    
    /// 根据尺寸压缩
    /// - Parameter maxLength: 最大字节
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
    
    /// 压缩 (根据质量和尺寸)
    /// - Parameter maxLength: 最大字节
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

public extension UIImage {
    /// Whether this image has alpha channel.
    var hasAlphaChannel: Bool {
        guard let cgImage = cgImage else { return false }
        let alpha = cgImage.alphaInfo.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        return  alpha == CGImageAlphaInfo.first.rawValue ||
                alpha == CGImageAlphaInfo.last.rawValue ||
                alpha == CGImageAlphaInfo.premultipliedFirst.rawValue ||
                alpha == CGImageAlphaInfo.premultipliedLast.rawValue
    }
}

public extension UIImage {
    
    /// Create a square image from apple emoji.
    /// - Parameters:
    ///   - emoji: single emoji, such as @"😄".
    ///   - size:  image's size.
    ///   - scale: The scale factor.  Default: UIScreen.main.scale
    convenience init?(emoji: String, size: CGFloat, scale: CGFloat = UIScreen.main.scale) {
        guard !emoji.isEmpty, scale > 1 else { return nil }
        let font = CTFontCreateWithName("AppleColorEmoji" as CFString, size * scale, nil)
        
        let string = NSAttributedString(string: emoji,
                                     attributes: [.font : font, .foregroundColor: UIColor.white.cgColor])
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedFirst.rawValue | CGImageByteOrderInfo.orderDefault.rawValue
        guard let context = CGContext(
                data: nil,
                width: Int(size * scale),
                height: Int(size * scale),
                bitsPerComponent: 8,
                bytesPerRow: 0,
                space: colorSpace,
                bitmapInfo: bitmapInfo) else {
            return nil
        }
        context.interpolationQuality = .high
        let line = CTLineCreateWithAttributedString(string)
        let frame = CTLineGetBoundsWithOptions(line, .useGlyphPathBounds)
        context.textPosition = CGPoint(x: 0, y: -frame.origin.y)
        CTLineDraw(line, context)
        guard let cgImage = context.makeImage() else { return nil }
        self.init(cgImage: cgImage, scale: scale, orientation: .up)
    }
    
    
    
    /// Create and return a 1x1 point size image with the given color.
    /// - Parameters:
    ///   - color: The color.
    ///   - size: New image's size.  Default: CGSize(width: 1, height: 1)
    ///   - scale: The scale factor.  Default: UIScreen.main.scale
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1), scale: CGFloat = UIScreen.main.scale) {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }

        color.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))

        guard let aCgImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else {
            return nil
        }
        self.init(cgImage: aCgImage)
    }
    
    /// Create and return an image with custom draw code.
    /// - Parameters:
    ///   - size: The image size.
    ///   - scale: The scale factor.  Default: UIScreen.main.scale
    ///   - draw: The draw block.
    convenience init?(size: CGSize, scale: CGFloat = UIScreen.main.scale, draw: (CGContext) -> Void) {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        draw(context)
        guard let aCgImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else {
            return nil
        }
        self.init(cgImage: aCgImage)
    }
}


public extension UIImage {
    
    /// Creates a copy of the receiver rotated by the given angle.
    ///
    ///      Rotate the image by 180°
    ///      image.byRotate(with: Measurement(value: 180, unit: .degrees), isFitSize: true)
    ///
    /// - Parameters:
    ///   - angle: The angle measurement by which to rotate the image.
    ///   - isFitSize: true: new image's size is extend to fit all content.  false: image's size will not change, content may be clipped.
    /// - Returns: optional UIImage (if applicable).
    func byRotate(with angle: Measurement<UnitAngle>, isFitSize: Bool = true) -> UIImage? {
        return byRotate(with: CGFloat(angle.converted(to: .radians).value), isFitSize: isFitSize)
    }
    
    /// Returns a new rotated image (relative to the center).
    /// - Parameters:
    ///   - radians: Rotated radians in counterclockwise.⟲
    ///   - isFitSize: true: new image's size is extend to fit all content.  false: image's size will not change, content may be clipped.
    /// - Returns: optional UIImage (if applicable).
    func byRotate(with radians: CGFloat, isFitSize: Bool = true) -> UIImage? {
        guard let cgImage = cgImage else { return nil }
        let width = cgImage.width
        let height = cgImage.height
        
        let rect = CGRect(x: 0, y: 0, width: width, height: height).applying(isFitSize ? CGAffineTransform(rotationAngle: radians) : .identity)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedFirst.rawValue | CGImageByteOrderInfo.orderDefault.rawValue
        guard let context = CGContext(
                data: nil,
                width: Int(rect.width),
                height: Int(rect.height),
                bitsPerComponent: 8,
                bytesPerRow: Int(rect.width) * 4,
                space: colorSpace,
                bitmapInfo: bitmapInfo) else {
            return nil
        }
        context.setShouldAntialias(true)
        context.setAllowsAntialiasing(true)
        context.interpolationQuality = .high
        context.translateBy(x: rect.width * 0.5, y: rect.height * 0.5)
        context.rotate(by: radians)
        context.draw(cgImage, in: .init(x: -CGFloat(width) * 0.5, y: -CGFloat(height) * 0.5, width: CGFloat(width), height: CGFloat(height)))
        return context.makeImage().map { UIImage(cgImage: $0, scale:  scale, orientation: imageOrientation)}
    }
    
    struct Axis: OptionSet {
        
        public let rawValue: Int
        public init(rawValue: Int) { self.rawValue = rawValue }
        
        public static let horizontal = Axis(rawValue: 1)
        
        public static let vertical = Axis(rawValue: 2)
    }
    /// Returns  a horizontally flipped image(⇋ ) and a vertically flipped image(⥯)
    /// - Parameters:
    ///   - horizontal: ⥯
    ///   - vertical: ⥯
    /// - Returns: optional UIImage (if applicable).
    func byFlip(_ axis: Axis = .horizontal) -> UIImage? {
        guard let cgImage = cgImage else { return nil }
        let width = cgImage.width
        let height = cgImage.height
        let bytesPerRow = width * 4
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedFirst.rawValue | CGImageByteOrderInfo.orderDefault.rawValue
        guard let context = CGContext(
                data: nil,
                width: width,
                height: height,
                bitsPerComponent: 8,
                bytesPerRow: bytesPerRow,
                space: colorSpace,
                bitmapInfo: bitmapInfo) else {
            return nil
        }
        
        context.draw(cgImage, in: .init(x: 0, y: 0, width: width, height: height))
        guard let data = context.data else {
            return nil
        }
        var src = vImage_Buffer(data: data, height: vImagePixelCount(height), width: vImagePixelCount(width), rowBytes: bytesPerRow)
        var dest = vImage_Buffer(data: data, height: vImagePixelCount(height), width: vImagePixelCount(width), rowBytes: bytesPerRow)
        if axis.contains(.horizontal) {
            vImageHorizontalReflect_ARGB8888(&src, &dest, vImage_Flags(kvImageBackgroundColorFill))
        }
        if axis.contains(.vertical) {
            vImageVerticalReflect_ARGB8888(&src, &dest, vImage_Flags(kvImageBackgroundColorFill))
        }
        return context.makeImage().map { UIImage(cgImage: $0, scale:  scale, orientation: imageOrientation)}
    }
    
   
    /// Returns a new image which is scaled from this image. The image will be stretched as needed.
    /// - Parameter size: The new size to be scaled, values should be positive.
    /// - Returns: optional UIImage (if applicable).
    func byResize(to size: CGSize) -> UIImage? {
        guard size.width > 0, size.height > 0 else { return nil }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /// Returns a new image which is scaled from this image. The image content will be changed with thencontentMode.
    /// - Parameters:
    ///   - size: The new size to be scaled, values should be positive.
    ///   - contentMode: The content mode for image content.
    /// - Returns: optional UIImage (if applicable).
    func byResize(to size: CGSize, contentMode: UIView.ContentMode) -> UIImage? {
        guard size.width > 0, size.height > 0 else { return nil }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        
        draw(in: CGRect(origin: .zero, size: size), with: contentMode, clipsToBounds: false)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /// Returns a new image which is cropped from this image.
    /// - Parameter rect: Image's inner rect.
    /// - Returns: optional UIImage (if applicable).
    func byCrop(to rect: CGRect) -> UIImage? {
        let rect = CGRect(
            x: rect.origin.x * scale,
            y: rect.origin.y * scale,
            width: rect.width * scale,
            height: rect.height * scale
        )
        
        guard size.width > 0, size.height > 0 else { return nil }
        guard let cgImage = cgImage?.cropping(to: rect) else { return nil }
        return UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
    }
    
    /// Returns a new image which is edge inset from this image.
    /// - Parameters:
    ///   - insets: Inset (positive) for each of the edges, values can be negative to 'outset'.
    ///   - color: Extend edge's fill color, nil means clear color.
    /// - Returns: optional UIImage (if applicable).
    func byInsetEdge(to insets: UIEdgeInsets, with color: UIColor? = .none) -> UIImage? {
        var _size = self.size
        _size.width -= insets.left + insets.right
        _size.height -= insets.top + insets.bottom
        guard size.width > 0, size.height > 0 else { return nil }
        let rect = CGRect(x: -insets.left, y: -insets.top, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        
        if let color = color {
            guard let context = UIGraphicsGetCurrentContext() else { return nil}
            context.setFillColor(color.cgColor)
            let path = CGMutablePath()
            path.addRect(CGRect(origin: .zero, size: _size))
            path.addRect(rect)
            context.addPath(path)
            context.fillPath()
        }
        draw(in: rect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /// Rounds a new image with a given corner size.
    /// - Parameters:
    ///   - corners: A description of fillet properties
    ///   - borderWidth: The inset border line width. Values larger than half the rectangle's width or height are clamped appropriately to half the width or height.
    ///   - borderColor:  The border stroke color. nil means clear color.
    ///   - borderLineJoin: The border line join.
    /// - Returns: optional UIImage (if applicable).
    func byRoundCornerRadius(to corners: RectCorner,
                             borderWidth: CGFloat = 0,
                             borderColor: UIColor? = .none,
                             borderLineJoin: CGLineJoin = .miter) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        let rect = CGRect(origin: .zero, size: size)
        context.scaleBy(x: 1, y: -1)
        context.translateBy(x: 0, y: -rect.height)
        let minSize = min(size.width, size.height)
        
        if borderWidth < minSize / 2 {
            let path = UIBezierPath(cgPath: corners.simd.path(rect.insetBy(dx: borderWidth, dy: borderWidth)))
            path.close()
            
            context.saveGState()
            path.addClip()
            cgImage.map { context.draw($0, in: rect)}
            context.restoreGState()
        }
        
        if let borderColor = borderColor,
            borderWidth < minSize / 2 ,
            borderWidth > 0 {
            let strokeInset = (floor(borderWidth * scale) + 0.5) / scale
            let strokeRect = rect.insetBy(dx: strokeInset, dy: strokeInset)
            let path = UIBezierPath(cgPath: corners.simd.path(strokeRect))
            path.close()
            path.lineWidth = borderWidth
            path.lineJoinStyle = borderLineJoin
            borderColor.setStroke()
            path.stroke()
        }
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /// Tint the image in alpha channel with the given color.
    /// - Parameter color: The color.
    /// - Returns: optional UIImage (if applicable).
    func byTintColor(to color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        let rect = CGRect(origin: .zero, size: size)
        color.set()
        
        UIRectFill(rect)
        draw(at: .zero, blendMode: .destinationIn, alpha: 1)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    
    /// Draws the entire image in the specified rectangle, content changed with the contentMode.
    ///
    ///  This method draws the entire image in the current graphics context,
    ///  respecting the image's orientation setting. In the default coordinate system,
    ///  images are situated down and to the right of the origin of the specified
    ///  rectangle. This method respects any transforms applied to the current graphics
    ///  context, however.
    ///
    /// - Parameters:
    ///   - rect: The rectangle in which to draw the image.
    ///   - contentMode: Draw content mode
    ///   - clipsToBounds:  A Boolean value that determines whether content are confined to the rect.  Default: false
    func draw(in rect: CGRect, with contentMode: UIView.ContentMode, clipsToBounds: Bool = false) {
        let drawRect: CGRect = rect.fit(with: size, contentMode: contentMode)
        guard size.width != 0, size.height != 0 else { return }
        if clipsToBounds {
            guard let context = UIGraphicsGetCurrentContext() else { return }
            context.saveGState()
            context.addRect(rect)
            context.clip()
            draw(in: drawRect)
            context.restoreGState()
            
        } else {
            draw(in: drawRect)
        }
    }
}

extension UIImage {
    
    /// 圆角属性描述
    public struct RectCorner: Equatable {
        public var topLeft: CGFloat
        public var topRight: CGFloat
        public var bottomLeft: CGFloat
        public var bottomRight: CGFloat
        
        public init(topLeft: CGFloat = 0, topRight: CGFloat = 0, bottomLeft: CGFloat = 0, bottomRight: CGFloat = 0) {
            self.topLeft = topLeft
            self.topRight = topRight
            self.bottomLeft = bottomLeft
            self.bottomRight = bottomRight
        }

        public static let zero: RectCorner = .init(topLeft: 0, topRight: 0, bottomLeft: 0, bottomRight: 0)
        
        var simd: RectCorner { RectCorner(topLeft: bottomLeft, topRight: bottomRight, bottomLeft: topLeft, bottomRight: topRight) }
        
        public func path(_ bounds: CGRect) -> CGPath {
            let minX = bounds.minX
            let minY = bounds.minY
            let maxX = bounds.maxX
            let maxY = bounds.maxY
            
            let topLeftCenter: CGPoint = .init(x: minX + topLeft, y: minY + topLeft)
            let topRightCenter: CGPoint = .init(x: maxX - topRight, y: minY + topRight)
            let bottomLeftCenter: CGPoint = .init(x: minX + bottomLeft, y: maxY - bottomLeft)
            let bottomRightCenter: CGPoint = .init(x: maxX - bottomRight, y: maxY - bottomRight)
            
            let path = CGMutablePath()
            path.addArc(
                center: topLeftCenter,
                radius: topLeft,
                startAngle: .pi,
                endAngle: .pi / 2 * 3,
                clockwise: false
            )
            path.addArc(
                center: topRightCenter,
                radius: topRight,
                startAngle: .pi / 2 * 3,
                endAngle: 0,
                clockwise: false
            )
            path.addArc(
                center: bottomRightCenter,
                radius: bottomRight,
                startAngle: 0,
                endAngle: .pi / 2,
                clockwise: false
            )
            path.addArc(
                center: bottomLeftCenter,
                radius: bottomLeft,
                startAngle: .pi / 2,
                endAngle: .pi,
                clockwise: false
            )
            path.closeSubpath()
            return path
        }
    }
}

extension CGRect {
    
    fileprivate func fit(with size: CGSize, contentMode: UIView.ContentMode) -> CGRect {
        var center: CGPoint { CGPoint(x: standardized.midX, y: standardized.midY) }
        var size: CGSize { CGSize(width: abs(size.width), height: abs(size.height))}
        
        switch contentMode {
        case .scaleAspectFit, .scaleAspectFill:
            let rect = standardized
            guard rect.size.width > 0.01, rect.size.height > 0.01, size.width > 0.01, size.height > 0.01 else {
                return CGRect(origin: center, size: .zero)
            }
            let scale: CGFloat
            switch contentMode {
            case .scaleAspectFit:
                if (size.width / size.height < rect.size.width / rect.size.height) {
                    scale = rect.size.height / size.height
                } else {
                    scale = rect.size.width / size.width
                }
                
            default:
                if (size.width / size.height < rect.size.width / rect.size.height) {
                    scale = rect.size.width / size.width
                } else {
                    scale = rect.size.height / size.height
                }
            }
            return CGRect(
                x: center.x - size.width * scale * 0.5,
                y: center.y - size.height * scale * 0.5,
                width: size.width * scale,
                height: size.height * scale
            )
            
        case .center:
            return CGRect(
                x: center.x - size.width * 0.5,
                y: center.y - size.height * 0.5,
                width: size.width,
                height: size.height
            )
            
        case .top:
            return CGRect(
                x: center.x - size.width * 0.5,
                y: standardized.origin.y,
                width: size.width,
                height: size.height
            )
            
        case .bottom:
            return CGRect(
                x: center.x - size.width * 0.5,
                y: standardized.origin.y + standardized.size.height - size.height,
                width: size.width,
                height: size.height
            )
            
        case .left:
            return CGRect(
                x: standardized.origin.x,
                y: center.y - size.height * 0.5,
                width: size.width,
                height: size.height
            )
            
        case .right:
            return CGRect(
                x: standardized.origin.x + standardized.size.width - size.width,
                y: center.y - size.height * 0.5,
                width: size.width,
                height: size.height
            )
            
        case .topLeft:
            return CGRect(origin: standardized.origin, size: size)
            
        case .topRight:
            return CGRect(
                x: standardized.origin.x + standardized.size.width - size.width,
                y: standardized.origin.y,
                width: size.width,
                height: size.height
            )
            
        case .bottomLeft:
            return CGRect(
                x: standardized.origin.x,
                y: standardized.origin.y + standardized.size.height - size.height,
                width: size.width,
                height: size.height
            )
            
        case .bottomRight:
            return CGRect(
                x: standardized.origin.x + standardized.size.width - size.width,
                y: standardized.origin.y + standardized.size.height - size.height,
                width: size.width,
                height: size.height
            )
            
        case .scaleToFill:      return standardized
        case .redraw:           return standardized
        default:                return standardized
        }
    }
}
