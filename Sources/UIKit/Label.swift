import UIKit

extension UILabel {
    
    open var requiredWidth: CGFloat {
        let rect = CGRect(
            x: 0,
            y: 0,
            width: .greatestFiniteMagnitude,
            height: frame.height
        )
        let label = UILabel(frame: rect)
        label.numberOfLines = numberOfLines
        label.lineBreakMode = lineBreakMode
        label.font = font
        label.text = text
        label.attributedText = attributedText
        label.sizeToFit()
        return label.frame.width
    }
}
