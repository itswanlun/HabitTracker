import UIKit

class GoalModeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var unitTextField: UITextField!
    @IBOutlet weak var enterValueTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    let fullScreenSize = UIScreen.main.bounds.size
    let unit = ["Count","Mins"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // 返回陣列 meals 的成員數量
           return unit.count
    }
    
    // UIPickerView 每個選項顯示的資料
    func pickerView(_ pickerView: UIPickerView,
      titleForRow row: Int,
      forComponent component: Int) -> String? {
        // 設置為陣列 meals 的第 row 項資料
        return unit[row]
    }

    // UIPickerView 改變選擇後執行的動作
    func pickerView(_ pickerView: UIPickerView,
      didSelectRow row: Int, inComponent component: Int) {
        // 依據元件的 tag 取得 UITextField
        let myTextField =
          self.view?.viewWithTag(100) as? UITextField

        // 將 UITextField 的值更新為陣列 meals 的第 row 項資料
        myTextField?.text = unit[row]
    }
    
    func setupUI() {
        saveButton.layer.cornerRadius = 10
        // 建立 UIPickerView
        let myPickerView = UIPickerView()

        // 設定 UIPickerView 的 delegate 及 dataSource
        myPickerView.delegate = self
        myPickerView.dataSource = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePicker))

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        unitTextField.inputAccessoryView = toolBar
        enterValueTextField.inputAccessoryView = toolBar


        // 將 UITextField 原先鍵盤的視圖更換成 UIPickerView
        unitTextField.inputView = myPickerView

        // 設置 UITextField 預設的內容
        unitTextField.text = unit[0]

        // 設置 UITextField 的 tag 以利後續使用
        unitTextField.tag = 100

        // 設置 UITextField 其他資訊並放入畫面中
        unitTextField.backgroundColor = UIColor.init(
          red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        unitTextField.textAlignment = .center
        unitTextField.center = CGPoint(
          x: fullScreenSize.width * 0.5,
          y: fullScreenSize.height * 0.15)
        self.view.addSubview(unitTextField)
    }
    
    @objc func donePicker(_ sender: UIBarButtonItem) {
        print(sender)
        unitTextField.resignFirstResponder()
        enterValueTextField.resignFirstResponder()
    }

}
