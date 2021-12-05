import UIKit

class AddHabitViewController: UIViewController {
    
    @IBOutlet weak var goalModleButton: UIButton!
    @IBOutlet weak var closeButtonItem: UIBarButtonItem!
    @IBAction func closeButtonItemTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    var goal: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goalModleButton.layer.cornerRadius = 5
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier  == "GoToGoalMode" {
            let destination = segue.destination as! GoalModeViewController
            destination.delegate = self
        }
    }

    @IBAction func GoalButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "GoToGoalMode", sender: self)
    }
}

extension AddHabitViewController: GoalModeViewControllerDelegate {
    func goalMode(_ viewController: GoalModeViewController, receivedGoal goal: Int) {
        self.goal = goal
    }
}
