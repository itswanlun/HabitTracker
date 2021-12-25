import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is NewHabitViewController {
            guard let viewController = UIStoryboard(name: "Habit", bundle: nil).instantiateViewController(withIdentifier: "HabitViewController") as? HabitViewController else { return true }
            
            viewController.strategy = CreateHabitStrategy()
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.modalPresentationStyle = .fullScreen
            navigationController.navigationBar.tintColor = .primaryColor
            present(navigationController, animated: true, completion: nil)
            
            return false
        }
        
        return true
    }
}
