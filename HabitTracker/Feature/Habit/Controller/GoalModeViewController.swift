import UIKit

enum GoalModeType: Int32 {
    case count
    case mins
    case ml
    
    var text: String {
        switch self {
        case .count:
            return "Count"
        case .mins:
            return "Mins"
        case .ml:
            return "ML"
        }
    }
}

protocol GoalModeViewControllerDelegate: AnyObject {
    func goalMode(_ viewController: GoalModeViewController, receivedUnit unit: GoalModeType, reveovedGoal goal: Int)
}

class GoalModeViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var unitTextField: UITextField!
    @IBOutlet weak var enterValueTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var isGoalTypeEnable: Bool = true
    private let toolBar = UIToolbar()
    private let myPickerView = UIPickerView()
    private let fullScreenSize = UIScreen.main.bounds.size
    private let unit: [GoalModeType] = [.count, .mins, .ml]
    
    weak var delegate: GoalModeViewControllerDelegate?
    var currentGoal: Int = 1
    var currentUnitType: GoalModeType = .count
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - IBAction
    @IBAction func saveButtonTapped(_ sender: Any) {
        delegate?.goalMode(self, receivedUnit: currentUnitType, reveovedGoal: currentGoal)
        
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Setup UI
extension GoalModeViewController {
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
        toolBar.tintColor = UIColor(rgb: 0xBFAE9F)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
    }
    
    private func setupTextField() {
        enterValueTextField.inputAccessoryView = toolBar
        enterValueTextField.text = "\(currentGoal)"
        enterValueTextField.addTarget(self, action: #selector(enterValueTextFieldChanged(_:)), for: .editingChanged)
        
        unitTextField.inputAccessoryView = toolBar
        unitTextField.inputView = myPickerView
        unitTextField.backgroundColor = UIColor(rgb: 0xBFAE9F)
        unitTextField.textAlignment = .center
        unitTextField.center = CGPoint(x: fullScreenSize.width * 0.5, y: fullScreenSize.height * 0.15)
        unitTextField.delegate = self
        unitTextField.text = currentUnitType.text
        unitTextField.isUserInteractionEnabled = isGoalTypeEnable
    }
}

// MARK: - Actions
extension GoalModeViewController {
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
extension GoalModeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return unit.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return unit[row].text
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let unit = unit[row]
        
        unitTextField.text = unit.text
        currentUnitType = unit
    }
}

extension GoalModeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
