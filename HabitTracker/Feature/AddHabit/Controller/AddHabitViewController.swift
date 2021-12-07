import UIKit

class AddHabitViewController: UIViewController {
    @IBOutlet weak var goalModleButton: UIButton!
    @IBOutlet weak var closeButtonItem: UIBarButtonItem!
    @IBAction func closeButtonItemTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var iconButton: UIButton!
    var goal: Int?
    var icon: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goalModleButton.layer.cornerRadius = 5
        goalModleButton.tintColor = UIColor.mainBlack
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier  == "GoToGoalMode" {
            let destination = segue.destination as! GoalModeViewController
            destination.delegate = self
        } else if segue.identifier == "GoToIcon" {
            let destinationIcon = segue.destination as! IconViewController
            destinationIcon.delegate = self
        }
    }

    @IBAction func GoalButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "GoToGoalMode", sender: self)
    }
    
    @IBAction func IconButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "GoToIcon", sender: self)
    }
}

extension AddHabitViewController: GoalModeViewControllerDelegate {
    func goalMode(_ viewController: GoalModeViewController, receivedUnit unit: GoalModeType, reveovedGoal goal: Int) {
        print(unit)
        print(goal)
        
        goalModleButton.setTitle("\(goal) \(unit)", for: .normal)
    }
}

extension AddHabitViewController: IconViewControllerDelegate {
    func Icon(_ viewController: IconViewController, receivedIcon icon: String) {
        print(icon)
        iconButton.setTitle("\(icon)", for: .normal)
    }
}
