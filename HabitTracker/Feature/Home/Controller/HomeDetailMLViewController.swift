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
        self.record = record
        
        updateProgress()
    }
}

// MARK: - Actions
extension HomeDetailMLViewController {
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
        guard let item = record else { return }
        
        returnButton.isHidden = true
        item.value += item.habit.quickAdd1
        
        do {
            try RecordMO.updateRecord(record: item)
            fetchDataFromDB(id: item.id)
        } catch {
            showMessage(title: "Error", message: "Something went wrong!")
        }
    }
    
    @IBAction func quicktwoTapped(_ sender: UIButton) {
        guard let item = record else { return }
        
        returnButton.isHidden = true
        item.value += item.habit.quickAdd2
        
        do {
            try RecordMO.updateRecord(record: item)
            fetchDataFromDB(id: item.id)
        } catch {
            showMessage(title: "Error", message: "Something went wrong!")
        }
    }
    
    @IBAction func quickthreeTapped(_ sender: UIButton) {
        guard let item = record else { return }
        
        returnButton.isHidden = true
        item.value += item.habit.quickAdd3
        
        do {
            try RecordMO.updateRecord(record: item)
            fetchDataFromDB(id: item.id)
        } catch {
            showMessage(title: "Error", message: "Something went wrong!")
        }
    }
    
    @IBAction func quickfourTapped(_ sender: UIButton) {
        guard let item = record else { return }
        
        let alertController = UIAlertController(title: "Enter value", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Enter value"
        }
        
        alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: { (_) in
            if let textField = alertController.textFields?.first,
               let text = textField.text,
               let value = Int(text),
                value < Int32.max {
                item.value += Int32(value)
                
                do {
                    try RecordMO.updateRecord(record: item)
                    self.fetchDataFromDB(id: item.id)
                } catch {
                    self.showMessage(title: "Error", message: "Something went wrong!")
                }
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
}

// MARK: - Setup UI
private extension HomeDetailMLViewController {
    func setupUI() {
        ringProgressView.ringWidth = 20
        ringProgressView.startColor = .primaryColor
        ringProgressView.endColor = .primaryColor
        
        quickoneButton.layer.cornerRadius = 5
        quicktwoButton.layer.cornerRadius = 5
        quickthreeButton.layer.cornerRadius = 5
        quickfourButton.layer.cornerRadius = 5
        
        quickoneButton.tintColor = .textColor
        quicktwoButton.tintColor = .textColor
        quickthreeButton.tintColor = .textColor
        quickfourButton.tintColor = .textColor
        
        if let item = record {
            navigationItem.setTitle(title: item.habit.name, subtitle: setupTitle(item.date))
            quickoneButton.setTitle(item.habit.quickAdd1Text, for: .normal)
            quicktwoButton.setTitle(item.habit.quickAdd2Text, for: .normal)
            quickthreeButton.setTitle(item.habit.quickAdd3Text, for: .normal)
            quickfourButton.setTitle("Other", for: .normal)
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
    
    func updateProgress() {
        progressLabel.text = record?.valueString ?? "0"
        percentLabel.text = record?.percentString ?? "0"
        ringProgressView.progress = record?.progress ?? 0
    }
    
    func openCurrentHabit(action: UIAlertAction) {
        self.performSegue(withIdentifier: "GoToHabitMinsMLSetting", sender: record)
    }
}
