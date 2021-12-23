import UIKit
import CoreData

class HabitViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var habitNameTextField: UITextField!
    @IBOutlet weak var goalModleButton: UIButton!
    @IBOutlet weak var iconButton: UIButton!
    @IBOutlet weak var quickActionsLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var quickAddOneButton: UIButton!
    @IBOutlet weak var quickAddTwoButton: UIButton!
    @IBOutlet weak var quickAddThreeButton: UIButton!
    
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
    
    var quickAdd1Button: Int = 5 {
        didSet {
            switch self.unitType {
            case .mins:
                self.quickAddOneButton.setTitle("\(quickAdd1Button)", for: .normal)
            case .ml:
                self.quickAddOneButton.setTitle("\(quickAdd1Button) ml", for: .normal)
            case .count:
                return
            }
        }
    }
    
    var quickAdd2Button: Int = 10 {
        didSet {
            switch self.unitType {
            case .mins:
                self.quickAddTwoButton.setTitle("\(quickAdd2Button)", for: .normal)
            case .ml:
                self.quickAddTwoButton.setTitle("\(quickAdd2Button) ml", for: .normal)
            case .count:
                return
            }
        }
    }
    
    var quickAdd3Button: Int = 15 {
        didSet {
            switch self.unitType {
            case .mins:
                self.quickAddThreeButton.setTitle("\(quickAdd3Button)", for: .normal)
            case .ml:
                self.quickAddThreeButton.setTitle("\(quickAdd3Button) ml", for: .normal)
            case .count:
                return
            }
        }
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        habitNameTextField.layer.cornerRadius = 5
        goalModleButton.layer.cornerRadius = 5
        iconButton.layer.cornerRadius = 5
        //goalModleButton.tintColor = UIColor.mainBlack
        quickAddOneButton.layer.cornerRadius = 5
        quickAddTwoButton.layer.cornerRadius = 5
        quickAddThreeButton.layer.cornerRadius = 5
        saveButton.layer.cornerRadius = 5
        
        hideCloseButton(strategy.isCancelButtonHidden())
        hideQuickActions(strategy.isQuickActiosHidden())
        updateFieldValuesIfNeed(strategy.habitID)
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(backButtonTapped(_:)))
        backButton.tintColor = UIColor(rgb: 0xBFAE9F)
        self.navigationItem.leftBarButtonItem = backButton
        
        habitNameTextField.setLeftPadding(10)
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
    
    // MARK: - IBAction
    @objc func backButtonTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
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
        
        // update
        if let habitID = strategy.habitID {
            do {
                try HabitMO.updateHabit(id: habitID, name: habitname, unitType: unitType, goal: goal, icon: icon, quickAdd1: quickAdd1Button, quickAdd2: quickAdd2Button, quickAdd3: quickAdd3Button)
                self.navigationController?.popToRootViewController(animated: true)
            } catch {
                print("👠")
            }
            // insert
        } else  {
            if HabitMO.insertHabit(name: habitname, unitType: unitType, goal: goal, icon: icon) {
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    private func showMessage(title: String? = nil, message: String? = nil) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(okAction)
        
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func quickAddOneButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Enter value", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in textField.placeholder = "Enter value" }
        alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: { (_) in
            if let textField = alertController.textFields?.first,
               let text = textField.text,
               let value = Int(text) {
                
                self.quickAdd1Button = Int(value)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
    
    @IBAction func quickAddTwoButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Enter value", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in textField.placeholder = "Enter value" }
        alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: { (_) in
            if let textField = alertController.textFields?.first,
               let text = textField.text,
               let value = Int(text) {
                
                self.quickAdd2Button = Int(value)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
    
    @IBAction func quickThreeButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Enter value", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in textField.placeholder = "Enter value" }
        alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: { (_) in
            if let textField = alertController.textFields?.first,
               let text = textField.text,
               let value = Int(text) {
                
                self.quickAdd3Button = Int(value)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
    
    
    private func updateFieldValuesIfNeed(_ habitID: UUID?) {
        if let id = habitID, let habit = HabitMO.fetchHabitbyId(id: id) {
            self.goal = Int(habit.goal)
            self.icon = habit.icon
            self.unitType = habit.unitTypeEnum
            self.quickAdd1Button = Int(habit.quickAdd1)
            self.quickAdd2Button = Int(habit.quickAdd2)
            self.quickAdd3Button = Int(habit.quickAdd3)
            
            habitNameTextField.text = habit.name
        }
    }
}

// MARK: - Setup UI
extension HabitViewController {
    private func hideCloseButton(_ isHidden: Bool) {
        if isHidden {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash.fill"),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(deleteHabitTapped))
            navigationItem.rightBarButtonItem?.tintColor = UIColor(rgb: 0xBFAE9F)
        }else{
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "multiply"),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(closedTapped))
            navigationItem.rightBarButtonItem?.tintColor = UIColor(rgb: 0xBFAE9F)
        }
    }
    
    private func hideQuickActions(_ isHidden: Bool) {
        if isHidden {
            quickActionsLabel.isHidden = true
            quickAddOneButton.isHidden = true
            quickAddTwoButton.isHidden = true
            quickAddThreeButton.isHidden = true
        } else {
            quickActionsLabel.isHidden = false
            quickAddOneButton.isHidden = false
            quickAddTwoButton.isHidden = false
            quickAddThreeButton.isHidden = false
        }
    }
    
    @objc func closedTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func deleteHabitTapped() {
        if let habitID = strategy.habitID {
            if RecordMO.deleteRecord(id: habitID) {
                HabitMO.deleteHabit(id: habitID)
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}

// MARK: - Delegate
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

extension UITextField {
    func setLeftPadding(_ spacing: CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: spacing))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
