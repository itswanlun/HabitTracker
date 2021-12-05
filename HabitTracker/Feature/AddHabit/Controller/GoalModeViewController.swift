import UIKit

protocol GoalModeViewControllerDelegate: AnyObject {
    func goalMode(_ viewController: GoalModeViewController, receivedGoal goal: Int)
}

class GoalModeViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var unitTextField: UITextField!
    @IBOutlet weak var enterValueTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    private let toolBar = UIToolbar()
    private let myPickerView = UIPickerView()
    private let fullScreenSize = UIScreen.main.bounds.size
    private let unit = ["Count", "Mins"]
    
    weak var delegate: GoalModeViewControllerDelegate?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - IBAction
    @IBAction func saveButtonTapped(_ sender: Any) {
        delegate?.goalMode(self, receivedGoal: 10)
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
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
    }
    
    private func setupTextField() {
        enterValueTextField.inputAccessoryView = toolBar
        
        unitTextField.inputAccessoryView = toolBar
        unitTextField.inputView = myPickerView
        unitTextField.text = unit[0]
        unitTextField.tag = 100
        unitTextField.backgroundColor = UIColor.init(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        unitTextField.textAlignment = .center
        unitTextField.center = CGPoint(x: fullScreenSize.width * 0.5, y: fullScreenSize.height * 0.15)
    }
}

// MARK: - Actions
extension GoalModeViewController {
    @objc func donePicker(_ sender: UIBarButtonItem) {
        print(sender)
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
        return unit[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let myTextField = self.view?.viewWithTag(100) as? UITextField
        myTextField?.text = unit[row]
    }
}
