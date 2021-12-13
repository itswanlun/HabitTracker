import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
    }
    
    // https://stackoverflow.com/questions/48909392/present-a-view-controller-modally-from-a-tab-bar-controller
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is NewHabitViewController {
            let viewController = UIStoryboard(name: "Habit", bundle: nil).instantiateViewController(withIdentifier: "HabitViewController") as! HabitViewController
            viewController.strategy = CreateHabitStrategy()
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true, completion: nil)
            
            return false
        }
        
        return true
    }
}
