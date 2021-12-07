import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        appendEmptyItem(at: 1)
        
        setupCenterButton()
    }
    
    func appendEmptyItem(at index: Int) {
        let controller = UIViewController()
        controller.title = ""
        controller.tabBarItem.isEnabled = false
        
        viewControllers?.insert(controller, at: index)
    }

    // https://coderedirect.com/questions/345772/swift-custom-tabbar-with-center-rounded-button
    func setupCenterButton() {
        let height: CGFloat = 26
        let width: CGFloat = 26
        let y = tabBar.frame.minY + 3
        let x = view.bounds.width/2 - width/2
        
        
        
        let menuButton = UIButton(frame: CGRect(x: x, y: y, width: width, height: height))
        menuButton.backgroundColor = UIColor.red
        let image = UIImage(systemName: "plus.circle.fill")?.withRenderingMode(.alwaysTemplate)
//        menuButton.setImage(image, for: .normal)
        menuButton.setBackgroundImage(image, for: .normal)
        menuButton.tintColor = .lightGray
//        menuButton.imageView?.contentMode = .scaleToFill
//        menuButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        view.addSubview(menuButton)
    
        menuButton.addTarget(self, action: #selector(menuButtonAction(sender:)), for: .touchUpInside)
        
        view.layoutIfNeeded()
    }
    
    @objc private func menuButtonAction(sender: UIButton) {
        let viewController = UIStoryboard(name: "AddHabit", bundle: nil).instantiateViewController(withIdentifier: "AddHabitNavigationController") as! UINavigationController
        
        self.present(viewController, animated: true, completion: nil)
        
    }
}
