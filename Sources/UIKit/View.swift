import UIKit

extension UIView {
    
    public static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    public static func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)?.first as! T
    }
}
