import UIKit

class HabitViewController: UIViewController {
    @IBOutlet weak var closeButtonItem: UIBarButtonItem!
    @IBOutlet weak var habitNameTextField: UITextField!
    @IBOutlet weak var goalModleButton: UIButton!
    @IBOutlet weak var iconButton: UIButton!
    
    var strategy: HabitStrategy = CreateHabitStrategy()
    var goal: Int = 1 {
        didSet {
            goalModleButton.setTitle("\(goal) \(unitType.text)", for: .normal)
        }
    }
    var icon: String = "🍎" {
        didSet {
            iconButton.setTitle("\(icon)", for: .normal)
        }
    }
    var unitType: GoalModeType = .count {
        didSet {
            goalModleButton.setTitle("\(goal) \(unitType.text)", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goalModleButton.layer.cornerRadius = 5
        goalModleButton.tintColor = UIColor.mainBlack
        
        hideCloseButton(strategy.isCancelButtonHidden())
        
        updateFieldValuesIfNeed(strategy.habitID)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier  == "GoToGoalMode" {
            let destination = segue.destination as! GoalModeViewController
            destination.delegate = self
            destination.currentGoal = goal
            destination.currentUnitType = unitType
            destination.isGoalTypeEnable = strategy.isGoalTypeEnable()
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
        guard let habitname = habitNameTextField.text, !habitname.isEmpty else {
            showMessage(title: "Warning", message: "Please enter habit name")
            return
        }
        
        if let habitID = strategy.habitID {
            let habit = Habit(id: habitID, name: habitname, unitType: unitType, goal: goal, icon: icon)
            
            do {
                try FakeDataSource.shared.updateHabit(habit: habit)
                
                self.navigationController?.popToRootViewController(animated: true)
            } catch {
                print("👠")
            }
        } else {
            let habit = Habit(id: UUID(), name: habitname, unitType: unitType, goal: goal, icon: icon)

            if FakeDataSource.shared.insertHabit(habit: habit) {
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func closeButtonItemTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    private func showMessage(title: String? = nil, message: String? = nil) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(okAction)
        
        present(controller, animated: true, completion: nil)
    }
    
    private func updateFieldValuesIfNeed(_ habitID: UUID?) {
        if let id = habitID, let habit = FakeDataSource.shared.fetchHabit(id: id) {
            self.goal = habit.goal
            self.icon = habit.icon
            self.unitType = habit.unitType
            
            habitNameTextField.text = habit.name
            
        }
    }
}

// MARK: - Setup UI
extension HabitViewController {
    private func hideCloseButton(_ isHidden: Bool) {
        if isHidden {
            closeButtonItem.isEnabled = false
            closeButtonItem.tintColor = .clear
        }else{
            closeButtonItem.isEnabled = true
            closeButtonItem.tintColor = nil
        }
    }
}

extension HabitViewController: GoalModeViewControllerDelegate {
    func goalMode(_ viewController: GoalModeViewController, receivedUnit unit: GoalModeType, reveovedGoal goal: Int) {
        self.goal = goal
        self.unitType = unit

        goalModleButton.setTitle("\(goal) \(unit)", for: .normal)
    }
}

extension HabitViewController: IconViewControllerDelegate {
    func Icon(_ viewController: IconViewController, receivedIcon icon: String) {
        print(icon)
        self.icon = icon
        iconButton.setTitle("\(icon)", for: .normal)
    }
}
