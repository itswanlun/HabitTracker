import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        appendEmptyItem(at: 1)
        
        setupCenterButton()
        
        tabBar.backgroundColor = .lightGray
    }
    
    func appendEmptyItem(at index: Int) {
        let controller = UIViewController()
        controller.title = ""
        controller.tabBarItem.isEnabled = false
        
        viewControllers?.insert(controller, at: index)
    }

    // https://coderedirect.com/questions/345772/swift-custom-tabbar-with-center-rounded-button
    func setupCenterButton() {
        let height: CGFloat = 44
        let width: CGFloat = 44
        let y = view.bounds.height - height - 30
        let x = view.bounds.width/2 - width/2
        let menuButton = UIButton(frame: CGRect(x: x, y: y, width: width, height: height))
        menuButton.backgroundColor = UIColor.red
        menuButton.layer.cornerRadius = height/2
        
        view.addSubview(menuButton)
    
        menuButton.addTarget(self, action: #selector(menuButtonAction(sender:)), for: .touchUpInside)
        
        view.layoutIfNeeded()
    }
    
    @objc private func menuButtonAction(sender: UIButton) {
        let viewController = UIStoryboard(name: "AddHabit", bundle: nil).instantiateViewController(withIdentifier: "AddHabitNavigationController") as! UINavigationController
        
        self.present(viewController, animated: true, completion: nil)
        
    }
}