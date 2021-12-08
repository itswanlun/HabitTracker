import UIKit

class AddHabitViewController: UIViewController {
    @IBOutlet weak var habitNameLabel: UILabel!
    @IBOutlet weak var goalModleButton: UIButton!
    @IBOutlet weak var closeButtonItem: UIBarButtonItem!
    @IBAction func closeButtonItemTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var iconButton: UIButton!
    var goal: Int? = 1
    var icon: String?
    var unitType: GoalModeType? = .count
    
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
    
    @IBAction func saveHabitTapped(_ sender: UIButton) {
        guard let goal = goal else {
            showMessage(title: "Warning", message: "Please fill out the goal")
            return
        }
        
        guard let unitType = unitType else {
            showMessage(title: "Warning", message: "Please fill out the unit")
            return
        }
        
        guard let icon = icon else {
            showMessage(title: "Warning", message: "Please select an icon")
            return
        }
        
        guard let habitname = habitNameLabel.text else {
            showMessage(title: "Warning", message: "Please enter habit name")
            return
        }
        
        let habit = Habit(id: UUID(), name: habitname, unitType: unitType, goal: goal, icon: icon)


        if FakeDataSource.shared.insertHabit(habit: habit) {
            dismiss(animated: true, completion: nil)
        }
    }
    
    private func showMessage(title: String? = nil, message: String? = nil) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(okAction)
        
        present(controller, animated: true, completion: nil)
    }
}

extension AddHabitViewController: GoalModeViewControllerDelegate {
    func goalMode(_ viewController: GoalModeViewController, receivedUnit unit: GoalModeType, reveovedGoal goal: Int) {
        self.goal = goal
        self.unitType = unit

        goalModleButton.setTitle("\(goal) \(unit)", for: .normal)
    }
}

extension AddHabitViewController: IconViewControllerDelegate {
    func Icon(_ viewController: IconViewController, receivedIcon icon: String) {
        print(icon)
        self.icon = icon
        iconButton.setTitle("\(icon)", for: .normal)
    }
}
