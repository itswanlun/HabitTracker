import UIKit
import MKRingProgressView

class HomeDetailMLViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var ringProgressView: RingProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var quickoneButton: UIButton!
    @IBOutlet weak var quicktwoButton: UIButton!
    @IBOutlet weak var quickthreeButton: UIButton!
    @IBOutlet weak var quickfourButton: UIButton!
    
    var record: Record?
    //var previousQuickTapped = 0

    // MARK: - IBAction
    @IBAction func returnTapped(_ sender: UIButton) {
        if var item = record {
            if item.value == 0 {
                return
            } else {
                item.value -= item.history[item.history.count - 1]
                item.history.remove(at: item.history.count - 1)
                
                if item.value == 0 {
                    returnButton.isHidden = true
                }
                
                do {
                    try FakeDataSource.shared.updateRecord(record: item)
                    fetchDataFromDB(id: item.id)
                } catch {
                    print("👠")
                }
            }
        }
    }
    
    @IBAction func quickoneTapped(_ sender: UIButton) {
        if var item = record {
            returnButton.isHidden = false
            item.history.append(item.habit.quickAdd1)
            //previousQuickTapped = item.habit.quickAdd1
            item.value += item.habit.quickAdd1
            
            do {
                try FakeDataSource.shared.updateRecord(record: item)
                fetchDataFromDB(id: item.id)
            } catch {
                print("👠")
            }
        }
    }
    
    @IBAction func quicktwoTapped(_ sender: UIButton) {
        if var item = record {
            returnButton.isHidden = false
            item.history.append(item.habit.quickAdd2)
            //previousQuickTapped = item.habit.quickAdd2
            item.value += item.habit.quickAdd2
            
            do {
                try FakeDataSource.shared.updateRecord(record: item)
                fetchDataFromDB(id: item.id)
            } catch {
                print("👠")
            }
        }
    }
    
    @IBAction func quickthreeTapped(_ sender: UIButton) {
        if var item = record {
            returnButton.isHidden = false
            item.history.append(item.habit.quickAdd3)
            //previousQuickTapped = item.habit.quickAdd3
            item.value += item.habit.quickAdd3
            
            do {
                try FakeDataSource.shared.updateRecord(record: item)
                fetchDataFromDB(id: item.id)
            } catch {
                print("👠")
            }
        }
    }
    
    @IBAction func quickfourTapped(_ sender: UIButton) {
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
}

// MARK: - Setup UI
extension HomeDetailMLViewController {
    private func setupUI() {
        ringProgressView.ringWidth = 20
        ringProgressView.startColor = UIColor(rgb: 0x535953)
        ringProgressView.endColor = UIColor(rgb: 0x535953)
        
        quickoneButton.layer.cornerRadius = 5
        quicktwoButton.layer.cornerRadius = 5
        quickthreeButton.layer.cornerRadius = 5
        quickfourButton.layer.cornerRadius = 5
        
        quickoneButton.tintColor = .white
        quicktwoButton.tintColor = .white
        quickthreeButton.tintColor = .white
        quickfourButton.tintColor = .white
        
        if let item = record {
            quickoneButton.setTitle("\(item.habit.quickAdd1)", for: .normal)
            quicktwoButton.setTitle("\(item.habit.quickAdd2)", for: .normal)
            quickthreeButton.setTitle("\(item.habit.quickAdd3)", for: .normal)
            quickfourButton.setTitle("\(item.habit.quickAdd4)", for: .normal)
            
            if item.value == 0 {
                returnButton.isHidden = true
            }
        }
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
}
