import UIKit
import MKRingProgressView

class HomeDetailViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var ringProgressView: RingProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var ididitButton: UIButton!
    @IBOutlet weak var undoButton: UIButton!
    
    var record: Record?
    
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
    
    @IBAction func minusTapped(_ sender: UIButton) {
        if var item = record {
            let value = item.value
            
            if value == 0 {
                return
            } else {
                item.value -= 1
                
                do {
                    try FakeDataSource.shared.updateRecord(record: item)
                    fetchDataFromDB(id: item.id)
                } catch {
                    print("👠")
                }
            }
        }
    }
    
    @IBAction func plusTapped(_ sender: UIButton) {
        if var item = record {
            let value = item.value
            let goal = item.habit.goal
            
            if value == goal {
                return
            } else {
                item.value += 1
                
                do {
                    try FakeDataSource.shared.updateRecord(record: item)
                    fetchDataFromDB(id: item.id)
                } catch {
                    print("👠")
                }
            }
        }
    }
    
    @IBAction func ididitTapped(_ sender: UIButton) {
        if var item = record {
            let value = item.value
            let goal = item.habit.goal
            
            if value == goal {
                return
            } else {
                item.value = goal
                
                do {
                    try FakeDataSource.shared.updateRecord(record: item)
                    fetchDataFromDB(id: item.id)
                } catch {
                    print("👠")
                }
            }
        }
    }
    
    @IBAction func undoTapped(_ sender: UIButton) {
        if var item = record {
            let value = item.value
            
            if value == 0 {
                return
            } else {
                item.value = 0
                
                do {
                    try FakeDataSource.shared.updateRecord(record: item)
                    fetchDataFromDB(id: item.id)
                } catch {
                    print("👠")
                }
            }
        }
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        if let record = record {
            fetchDataFromDB(id: record.id)
        }
    }
    
    func fetchDataFromDB(id: UUID) {
        let record = FakeDataSource.shared.fetchRecord(id: id)
        self.record = record
        
        updateProgress()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier  == "GoToHabitCountSetting" {
            let destination = segue.destination as! HabitViewController
            
            if let record = sender as? Record {
                destination.strategy = EditHabitStrategy(habitID: record.habit.id)
            }
//            if let record = sender as? Record {
//                destination.record = record
//            }
        } else if segue.identifier  == "GoToHabitMinsMLSetting" {
            let destination = segue.destination as! HabitViewController
            if let record = sender as? Record {
                destination.strategy = EditHabitStrategy(habitID: record.habit.id)
            }
        }
    }
}

// MARK: - Setup UI
extension HomeDetailViewController {
    private func setupUI() {
        ringProgressView.ringWidth = 20
        ringProgressView.startColor = UIColor(rgb: 0x535953)
        ringProgressView.endColor = UIColor(rgb: 0x535953)
    }
    
    private func updateProgress() {
        if let item = record {
            setupProgressLabel(value: item.value, goal: item.habit.goal)
            setupProgress(value: item.value, goal: item.habit.goal)
        } else {
            setupProgressLabel(value: 0, goal: 0)
            setupProgress(value: 0, goal: 0)
        }
    }
    
    private func setupProgressLabel(value: Int, goal: Int) {
        progressLabel.text = "\(value)" + " / " + "\(goal)"
    }
    
    private func setupProgress(value: Int, goal: Int) {
        ringProgressView.progress = Double(Float(value)/Float(goal))
    }
    
    private func openCurrentHabit(action: UIAlertAction) {
        self.performSegue(withIdentifier: "GoToHabitCountSetting", sender: record)
    }
}
