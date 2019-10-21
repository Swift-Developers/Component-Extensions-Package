import UIKit

public protocol UIViewControllerType {
  func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
}

extension UIViewController {
    
    /// 添加子控制器
    /// - Parameter controller: 控制器
    /// - Parameter container: 容器视图 默认为父控制器view
    func add(child controller: UIViewController, to container: UIView? = .none) {
        addChild(controller)
        (container ?? view)?.addSubview(controller.view)
        controller.view.frame = (container ?? view).bounds
        controller.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        controller.didMove(toParent: self)
    }
    
    /// 移除子控制器
    /// - Parameter controller: 控制器
    func remove(child controller: UIViewController) {
        controller.willMove(toParent: nil)
        controller.view.removeFromSuperview()
        controller.removeFromParent()
    }
    
    /// 推出控制器 无NavigationController时则present一个NavigationController
    /// - Parameter controller: 控制器
    /// - Parameter animated: 是否动画
    func push(_ controller: UIViewController, from nav: UINavigationController.Type = UINavigationController.self, animated: Bool = true) {
        if let navigation = self as? UINavigationController {
            navigation.pushViewController(controller, animated: animated)
            
        } else if let navigation = navigationController {
            navigation.pushViewController(controller, animated: animated)
            
        } else {
            let navigation = nav.init(rootViewController: controller)
            navigation.modalPresentationStyle = .fullScreen
            present(navigation, animated: animated)
        }
    }
}

extension UIViewController {
    
    @IBAction func endEditing() {
        view.endEditing(true)
    }
    
    @IBAction func close() {
        view.endEditing(true)
        if
            let navigation = navigationController,
            navigation.viewControllers.first != self {
            guard let _ = presentedViewController else {
                navigation.popViewController(animated: true)
                return
            }
            dismiss(animated: true) {
                navigation.popViewController(animated: true)
            }
            
        } else {
            let presenting = presentingViewController ?? self
            presenting.dismiss(animated: true)
        }
    }
}

extension UIViewController {
    
    /// 是否竖屏
    public var isPortrait: Bool {
        guard
            supportedInterfaceOrientations == .allButUpsideDown ||
            supportedInterfaceOrientations == .all ||
            supportedInterfaceOrientations == .portrait ||
            supportedInterfaceOrientations == .portraitUpsideDown else {
            return false
        }
        
        return UIApplication.shared.statusBarOrientation.isPortrait
    }
    
    /// 是否横屏
    public var isLandscape: Bool {
        guard
            supportedInterfaceOrientations == .allButUpsideDown ||
            supportedInterfaceOrientations == .all ||
            supportedInterfaceOrientations == .landscape ||
            supportedInterfaceOrientations == .landscapeRight ||
            supportedInterfaceOrientations == .landscapeLeft else {
            return false
        }
        
        return UIApplication.shared.statusBarOrientation.isLandscape
    }
    
    /// 控制器方向
    public var orientation: UIInterfaceOrientation {
        get { return  UIApplication.shared.statusBarOrientation }
        set {
            let value: Int
            switch newValue {
            case .portrait:             value = UIDeviceOrientation.portrait.rawValue
            case .portraitUpsideDown:   value = UIDeviceOrientation.portraitUpsideDown.rawValue
            case .landscapeLeft:        value = UIDeviceOrientation.landscapeLeft.rawValue
            case .landscapeRight:       value = UIDeviceOrientation.landscapeRight.rawValue
            default:                    value = UIDeviceOrientation.portrait.rawValue
            }
            UIDevice.current.setValue(value, forKey: "orientation")
            UIViewController.attemptRotationToDeviceOrientation()
        }
    }
}
