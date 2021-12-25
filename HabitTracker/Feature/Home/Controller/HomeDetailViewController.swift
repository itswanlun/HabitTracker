import UIKit
import MKRingProgressView

class HomeDetailViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var ringProgressView: RingProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var ididitButton: UIButton!
    @IBOutlet weak var undoButton: UIButton!
    
    var record: RecordMO?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        if let record = record {
            fetchDataFromDB(id: record.id)
        }
    }
    
    func fetchDataFromDB(id: UUID) {
        let record = RecordMO.fetchRecord(id: id)
        self.record = record
        
        updateProgress()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier  == "GoToHabitCountSetting" {
            let destination = segue.destination as! HabitViewController
            
            if let record = sender as? RecordMO {
                destination.strategy = EditHabitStrategy(habitID: record.habit.id, unit: record.habit.unitTypeEnum)
            }
        } else if segue.identifier  == "GoToHabitMinsMLSetting" {
            let destination = segue.destination as! HabitViewController
            if let record = sender as? RecordMO {
                destination.strategy = EditHabitStrategy(habitID: record.habit.id, unit: record.habit.unitTypeEnum)
            }
        }
    }
}

// MARK: - Actions
extension HomeDetailViewController {
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
    
    @IBAction func minusTapped(_ sender: UIButton) {
        guard let item = record, item.value > 0 else { return }
       
        do {
            item.value -= 1
            try RecordMO.updateRecord(record: item)
            fetchDataFromDB(id: item.id)
        } catch {
            showMessage(title: "Error", message: "Something went wrong!")
        }
    }
    
    @IBAction func plusTapped(_ sender: UIButton) {
        guard let item = record, item.value < item.habit.goal else { return }
        
        do {
            item.value += 1
            try RecordMO.updateRecord(record: item)
            fetchDataFromDB(id: item.id)
        } catch {
            showMessage(title: "Error", message: "Something went wrong!")
        }
    }
    
    @IBAction func iDidItButtonTapped(_ sender: UIButton) {
        guard let item = record, item.value < item.habit.goal else { return }
        
        do {
            item.value = item.habit.goal
            try RecordMO.updateRecord(record: item)
            fetchDataFromDB(id: item.id)
        } catch {
            showMessage(title: "Error", message: "Something went wrong!")
        }
    }
    
    @IBAction func undoTapped(_ sender: UIButton) {
        guard let item = record, item.value > 0 else { return }
        
        do {
            item.value = 0
            try RecordMO.updateRecord(record: item)
            fetchDataFromDB(id: item.id)
        } catch {
            showMessage(title: "Error", message: "Something went wrong!")
        }
    }
}

// MARK: - Setup UI
extension HomeDetailViewController {
    private func setupUI() {
        ringProgressView.ringWidth = 20
        ringProgressView.startColor = .primaryColor
        ringProgressView.endColor = .primaryColor
        
        ididitButton.layer.cornerRadius = 5
        undoButton.layer.cornerRadius = 5
        
        if let item = record {
            self.navigationItem.setTitle(title: item.habit.name, subtitle: setupTitle(item.date))
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
            setupProgressLabel(value: Int(item.value), goal: Int(item.habit.goal))
        } else {
            setupProgressLabel(value: 0, goal: 0)
        }
        
        ringProgressView.progress = record?.progress ?? 0
    }
    
    private func setupProgressLabel(value: Int, goal: Int) {
        progressLabel.text = "\(value)"
        goalLabel.text = " / " + "\(goal)"
    }
    
    private func openCurrentHabit(action: UIAlertAction) {
        self.performSegue(withIdentifier: "GoToHabitCountSetting", sender: record)
    }
}
