import UIKit

extension UIViewController {
    
    /// 添加子控制器
    /// - Parameter controller: 控制器
    /// - Parameter container: 容器视图 默认为父控制器view
    @objc
    open func add(child controller: UIViewController, to container: UIView? = .none) {
        addChild(controller)
        (container ?? view)?.addSubview(controller.view)
        controller.view.frame = (container ?? view).bounds
        controller.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        controller.didMove(toParent: self)
    }
    
    /// 从父控制器移除
    @objc
    open func removeFromParentController() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    /// 推出控制器 无NavigationController时则present一个NavigationController
    /// - Parameter controller: 控制器
    /// - Parameter animated: 是否动画
    @objc
    open func push(_ controller: UIViewController, from nav: UINavigationController.Type = UINavigationController.self, animated: Bool = true) {
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
    
    /// 结束编辑 收起键盘
    @IBAction
    open func endEditing() {
        view.endEditing(true)
    }
    
    /// 关闭视图控制器
    @IBAction
    open func close() {
        close { }
    }
    
    @objc
    open func close(with completion: @escaping () -> Void) {
        endEditing()
        guard
            let navigation = navigationController,
            navigation.viewControllers.first != self else {
            let presenting = presentingViewController ?? self
            presenting.dismiss(animated: true, completion: completion)
            return
        }
        guard presentedViewController == nil else {
            dismiss(animated: true) { [weak self] in self?.close(with: completion) }
            return
        }
        
        func parents(_ controller: UIViewController) -> [UIViewController] {
            guard let parent = controller.parent else {
                return [controller]
            }
            return [controller] + parents(parent)
        }
        
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        if let top = navigation.topViewController, parents(self).contains(top) {
            navigation.popViewController(animated: true)
            
        } else {
            let temp = navigation.viewControllers.filter { !parents(self).contains($0) }
            navigation.setViewControllers(temp, animated: true)
        }
        CATransaction.commit()
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
            case .landscapeLeft:        value = UIDeviceOrientation.landscapeRight.rawValue
            case .landscapeRight:       value = UIDeviceOrientation.landscapeLeft.rawValue
            default:                    value = UIDeviceOrientation.portrait.rawValue
            }
            UIDevice.current.setValue(value, forKey: "orientation")
            UIViewController.attemptRotationToDeviceOrientation()
        }
    }
}
