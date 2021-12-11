import UIKit

protocol EditHabitGoalModeViewControllerDelegate: AnyObject {
    func goalMode(_ viewController: EditHabitGoalModeViewController, receivedUnit unit: GoalModeType, reveovedGoal goal: Int)
}

class EditHabitGoalModeViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var unitTextField: UITextField!
    @IBOutlet weak var enterValueTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    private let toolBar = UIToolbar()
    private let myPickerView = UIPickerView()
    private let fullScreenSize = UIScreen.main.bounds.size
    
    
    weak var delegate: EditHabitGoalModeViewControllerDelegate?
    var record: Record?
    var currentGoal: Int = 1
    private let unit: [GoalModeType] = [.count, .mins, .ml]
    var currentUnitType: GoalModeType = .count
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - IBAction
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        if var record = record {
            record.habit.goal = currentGoal
            record.habit.unitType = currentUnitType
            
            do {
                try FakeDataSource.shared.updateRecord(record: record)
            } catch {
                print("👠")
            }
        }
        
        delegate?.goalMode(self, receivedUnit: currentUnitType, reveovedGoal: currentGoal)
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - Setup UI
extension EditHabitGoalModeViewController {
    private func setupUI() {
        setupSaveButton()
        setupToolbar()
        setupPicker()
        setupTextField()
    }
    
    private func setupSaveButton() {
        saveButton.layer.cornerRadius = 10
    }
    
    private func setupPicker() {
        myPickerView.delegate = self
        myPickerView.dataSource = self
    }
    
    private func setupToolbar() {
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
    }
    
    private func setupTextField() {
        if let record = record {
            currentGoal = record.habit.goal
            currentUnitType = record.habit.unitType
        }
        
        enterValueTextField.inputAccessoryView = toolBar
        enterValueTextField.text = "\(currentGoal)"
        enterValueTextField.addTarget(self, action: #selector(enterValueTextFieldChanged(_:)), for: .editingChanged)
        
        unitTextField.inputAccessoryView = toolBar
        unitTextField.inputView = myPickerView
        unitTextField.backgroundColor = UIColor.init(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        unitTextField.textAlignment = .center
        unitTextField.center = CGPoint(x: fullScreenSize.width * 0.5, y: fullScreenSize.height * 0.15)
        unitTextField.delegate = self
        unitTextField.text = currentUnitType.text
    }
}

// MARK: - Actions
extension EditHabitGoalModeViewController {
    @objc func enterValueTextFieldChanged(_ sender: UITextField) {
        guard let text = sender.text else { return }
        
        currentGoal = Int(text) ?? currentGoal
    }
    
    @objc func donePicker(_ sender: UIBarButtonItem) {
        unitTextField.resignFirstResponder()
        enterValueTextField.resignFirstResponder()
    }
}

// MARK: - UIPickerViewDelegate
extension EditHabitGoalModeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let record = record {
            switch record.habit.unitType {
            case .count:
                return unit[0].text
            case .mins:
                return unit[1].text
            case .ml:
                return unit[2].text
            }
        } else {
            return nil
        }
        //return unit[row].text
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let unit = unit[row]
        
        unitTextField.text = unit.text
        currentUnitType = unit
    }
}

extension EditHabitGoalModeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    
}
