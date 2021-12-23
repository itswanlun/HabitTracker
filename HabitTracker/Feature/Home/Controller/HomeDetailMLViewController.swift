import UIKit
import MKRingProgressView
import CoreData

class HomeDetailMLViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var ringProgressView: RingProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var quickoneButton: UIButton!
    @IBOutlet weak var quicktwoButton: UIButton!
    @IBOutlet weak var quickthreeButton: UIButton!
    @IBOutlet weak var quickfourButton: UIButton!
    @IBOutlet weak var rightBarButtonItem: UIBarButtonItem!
    var record: RecordMO?
    
    // MARK: - IBAction
    @IBAction func leftBarButtonItem(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func rightBarButtonItem(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Habit Settings", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Habit Settings", style: .default, handler: openCurrentHabit))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(alertController, animated: true)
    }
    
    @IBAction func quickoneTapped(_ sender: UIButton) {
        if var item = record {
            returnButton.isHidden = true
            item.value += item.habit.quickAdd1
            
            do {
                //try FakeDataSource.shared.updateRecord(record: item)
                try RecordMO.updateRecord(record: item)
                fetchDataFromDB(id: item.id)
            } catch {
                print("👠")
            }
        }
    }
    
    @IBAction func quicktwoTapped(_ sender: UIButton) {
        if var item = record {
            returnButton.isHidden = true
            //previousQuickTapped = item.habit.quickAdd2
            item.value += item.habit.quickAdd2
            
            do {
                //try FakeDataSource.shared.updateRecord(record: item)
                try RecordMO.updateRecord(record: item)
                fetchDataFromDB(id: item.id)
            } catch {
                print("👠")
            }
        }
    }
    
    @IBAction func quickthreeTapped(_ sender: UIButton) {
        if var item = record {
            returnButton.isHidden = true
            item.value += item.habit.quickAdd3
            
            do {
                //try FakeDataSource.shared.updateRecord(record: item)
                try RecordMO.updateRecord(record: item)
                fetchDataFromDB(id: item.id)
            } catch {
                print("👠")
            }
        }
    }
    
    @IBAction func quickfourTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Enter value", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Enter value"
        }
        
        alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: { (_) in
            if var item = self.record,
               let textField = alertController.textFields?.first,
               let text = textField.text,
               let value = Int(text) {
                item.value += Int32(value)
                
                do {
                    //try FakeDataSource.shared.updateRecord(record: item)
                    try RecordMO.updateRecord(record: item)
                    self.fetchDataFromDB(id: item.id)
                } catch {
                    print("👠")
                }
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        if let record = record {
            fetchDataFromDB(id: record.id)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier  == "GoToHabitMinsMLSetting" {
            let destination = segue.destination as! HabitViewController
            
            if let record = sender as? RecordMO {
                destination.strategy = EditHabitStrategy(habitID: record.habit.id, unit: record.habit.unitTypeEnum)
            }
        }
    }
    
    func fetchDataFromDB(id: UUID) {
        let record = RecordMO.fetchRecord(id: id)
        //let record = FakeDataSource.shared.fetchRecord(id: id)
        self.record = record
        
        updateProgress()
    }
}

// MARK: - Setup UI
extension HomeDetailMLViewController {
    private func setupUI() {
        ringProgressView.ringWidth = 20
        ringProgressView.startColor = UIColor(rgb: 0xBFAE9F)
        ringProgressView.endColor = UIColor(rgb: 0xBFAE9F)
        
        quickoneButton.layer.cornerRadius = 5
        quicktwoButton.layer.cornerRadius = 5
        quickthreeButton.layer.cornerRadius = 5
        quickfourButton.layer.cornerRadius = 5
        
        quickoneButton.tintColor = .white
        quicktwoButton.tintColor = .white
        quickthreeButton.tintColor = .white
        quickfourButton.tintColor = .white
        
        if let item = record {
            self.navigationItem.setTitle(title: item.habit.name, subtitle: setupTitle(item.date))

            switch item.habit.unitTypeEnum {
            case .ml:
                quickoneButton.setTitle("\(item.habit.quickAdd1)ml", for: .normal)
                quicktwoButton.setTitle("\(item.habit.quickAdd2)ml", for: .normal)
                quickthreeButton.setTitle("\(item.habit.quickAdd3)ml", for: .normal)
                quickfourButton.setTitle("Other", for: .normal)
            case .mins:
                quickoneButton.setTitle("\(item.habit.quickAdd1)min", for: .normal)
                quicktwoButton.setTitle("\(item.habit.quickAdd2)min", for: .normal)
                quickthreeButton.setTitle("\(item.habit.quickAdd3)min", for: .normal)
                quickfourButton.setTitle("Other", for: .normal)
            case .count:
                quickoneButton.setTitle("\(item.habit.quickAdd1)", for: .normal)
                quicktwoButton.setTitle("\(item.habit.quickAdd2)", for: .normal)
                quickthreeButton.setTitle("\(item.habit.quickAdd3)", for: .normal)
                quickfourButton.setTitle("Other", for: .normal)
            }
            
            returnButton.isHidden = true
        }
    }
    
    func setupTitle(_ date: Date) -> String {
        if date.isToday {
            return  "Today"
        } else if date.isYesterday {
            return "Yesterday"
        } else if date.isTomorrow {
            return "Tomorrow"
        } else {
            return date.toString("MMM dd")
        }
    }
    
    private func updateProgress() {
        if let item = record {
            setupProgressLabel(value: Int(item.value), goal: Int(item.habit.goal), unit: item.habit.unitTypeEnum)
            setupProgress(value: Int(item.value), goal: Int(item.habit.goal))
        } else {
            setupProgressLabel(value: 0, goal: 0, unit: .count)
            setupProgress(value: 0, goal: 0)
        }
    }
    
    private func setupProgressLabel(value: Int, goal: Int, unit: GoalModeType) {
        let percent = Int((Float(value)/Float(goal)) * 100)
        switch unit {
        case .mins:
            progressLabel.text = "\(value)mins"
        case .ml:
            progressLabel.text = "\(value)ml"
        case .count:
            progressLabel.text = "\(value)"
        }

        percentLabel.text = "\(percent)%"
    }
    
    private func setupProgress(value: Int, goal: Int) {
        ringProgressView.progress = Double(Float(value)/Float(goal))
    }
    
    private func openCurrentHabit(action: UIAlertAction) {
        self.performSegue(withIdentifier: "GoToHabitMinsMLSetting", sender: record)
    }
}
