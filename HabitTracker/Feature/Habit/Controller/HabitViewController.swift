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
            goalModleButton.setTitle("\(goal) \(unitType.unitText)", for: .normal)
        }
    }
    var icon: String = DataSource.shared.icons.first! {
        didSet {
            iconButton.setTitle("\(icon)", for: .normal)
        }
    }
    var unitType: GoalModeType = .count {
        didSet {
            goalModleButton.setTitle("\(goal) \(unitType.unitText)", for: .normal)
        }
    }
    
    var quickAddOneValue: Int = 5 {
        didSet {
            setupQuickAddButtonTitle(quickAddOneButton, value: quickAddOneValue)
        }
    }
    
    var quickAddTwoValue: Int = 10 {
        didSet {
            setupQuickAddButtonTitle(quickAddTwoButton, value: quickAddTwoValue)
        }
    }
    
    var quickAddThreeValue: Int = 15 {
        didSet {
            setupQuickAddButtonTitle(quickAddThreeButton, value: quickAddThreeValue)
        }
    }
    
    private let toolBar = UIToolbar()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
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
}

// MARK: - IBAction
extension HabitViewController {
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
        
        if let habitID = strategy.habitID {
            do {
                try HabitMO.updateHabit(id: habitID, name: habitname, unitType: unitType, goal: goal, icon: icon, quickAdd1: quickAddOneValue, quickAdd2: quickAddTwoValue, quickAdd3: quickAddThreeValue)
                self.navigationController?.popToRootViewController(animated: true)
            } catch {
                showMessage(title: "Error", message: "Something went wrong!")
            }
        } else  {
            if HabitMO.insertHabit(name: habitname, unitType: unitType, goal: goal, icon: icon) {
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func quickAddOneButtonTapped(_ sender: UIButton) {
        alertTextField(completionHandler: { result in
            self.quickAddOneValue = result
        })
    }
    
    @IBAction func quickAddTwoButtonTapped(_ sender: UIButton) {
        alertTextField(completionHandler: { result in
            self.quickAddTwoValue = result
        })
    }
    
    @IBAction func quickThreeButtonTapped(_ sender: UIButton) {
        alertTextField(completionHandler: { result in
            self.quickAddThreeValue = result
        })
    }
    
    func alertTextField(completionHandler: @escaping (Int) -> Void) {
        let alertController = UIAlertController(title: "Enter value", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in textField.placeholder = "Enter value" }
        alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: { (_) in
            if let textField = alertController.textFields?.first,
               let text = textField.text,
               let value = Int(text) {
                
                completionHandler(Int(value))
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
    
    @objc func closedTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func deleteHabitTapped() {
        showCheckMessage(title: "Warning", message: "Are you sure want to remove this habit?", completionHandler: { [weak self] in
            guard let self = self else { return }
            if let habitID = self.strategy.habitID {
                if RecordMO.deleteRecord(id: habitID) {
                    HabitMO.deleteHabit(id: habitID)
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        })
    }
    
    @objc func donePicker(_ sender: UIBarButtonItem) {
        habitNameTextField.resignFirstResponder()
    }
    
    private func setupQuickAddButtonTitle(_ button: UIButton, value: Int) {
        button.setTitle("\(value) \(unitType.unitText)", for: .normal)
    }
    
    private func updateFieldValuesIfNeed(_ habitID: UUID?) {
        if let id = habitID, let habit = HabitMO.fetchHabitbyId(id: id) {
            self.goal = Int(habit.goal)
            self.icon = habit.icon
            self.unitType = habit.unitTypeEnum
            self.quickAddOneValue = Int(habit.quickAdd1)
            self.quickAddTwoValue = Int(habit.quickAdd2)
            self.quickAddThreeValue = Int(habit.quickAdd3)
            
            habitNameTextField.text = habit.name
        }
    }
}

// MARK: - Setup UI
private extension HabitViewController {
    func setupUI() {
        setupHabitNameTextField()
        goalModleButton.layer.cornerRadius = 5
        iconButton.layer.cornerRadius = 5
        quickAddOneButton.layer.cornerRadius = 5
        quickAddTwoButton.layer.cornerRadius = 5
        quickAddThreeButton.layer.cornerRadius = 5
        saveButton.layer.cornerRadius = 5
        
        quickAddOneButton.tintColor = .textColor
        quickAddTwoButton.tintColor = .textColor
        quickAddThreeButton.tintColor = .textColor
        
        hideCloseButton(strategy.isCancelButtonHidden())
        hideQuickActions(strategy.isQuickActiosHidden())
        updateFieldValuesIfNeed(strategy.habitID)
    }
    
    func setupHabitNameTextField() {
        setupToolbar()
        habitNameTextField.setLeftPadding(10)
        habitNameTextField.inputAccessoryView = toolBar
        habitNameTextField.layer.cornerRadius = 5
        habitNameTextField.returnKeyType = .done
        habitNameTextField.delegate = self
    }
    
    func setupToolbar() {
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .primaryColor
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
    }
    
    func hideCloseButton(_ isHidden: Bool) {
        if isHidden {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "trash.fill"),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(deleteHabitTapped))
            navigationItem.rightBarButtonItem?.tintColor = .primaryColor
        }else{
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "multiply"),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(closedTapped))
            navigationItem.rightBarButtonItem?.tintColor = .primaryColor
        }
    }
    
    func hideQuickActions(_ isHidden: Bool) {
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
}

// MARK: - Delegate
extension HabitViewController: GoalModeViewControllerDelegate {
    func goalMode(_ viewController: GoalModeViewController, receivedUnit unit: GoalModeType, reveovedGoal goal: Int) {
        self.goal = goal
        self.unitType = unit
        
        goalModleButton.setTitle("\(goal) \(unit.unitText)", for: .normal)
    }
}

extension HabitViewController: IconViewControllerDelegate {
    func Icon(_ viewController: IconViewController, receivedIcon icon: String) {
        self.icon = icon
        iconButton.setTitle("\(icon)", for: .normal)
    }
}

extension HabitViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
