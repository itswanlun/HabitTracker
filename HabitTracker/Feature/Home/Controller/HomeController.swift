import UIKit
import CoreData

class HomeController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var rightBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var leftBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet var emptyHabitView: UIView!
    
    // MARK: - Private
    private var habitData: [HabitMO] = []
    private var recordData: [RecordMO] = []
    
    private var selectedDateUndoneRecord: [RecordMO] = [] {
        didSet {
            homeTableView.reloadData()
        }
    }
    
    private var selectedDateDoneRecord: [RecordMO] = [] {
        didSet {
            homeTableView.reloadData()
        }
    }
    
    private var selectedDate = Date() {
        didSet {
            setupTitle(selectedDate)
            checkAndSetRightBarButtonIsEnable(selectedDate)
            filterCurrentSelectedDateRecordData(selectedDate)
        }
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeTableView.backgroundView = emptyHabitView
        homeTableView.backgroundView?.isHidden = true
        homeTableView.separatorStyle = .none
        
        navigationItem.leftBarButtonItem?.tintColor = .primaryColor
        
        selectData()
        filterCurrentSelectedDateRecordData(selectedDate)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        selectData()
        filterCurrentSelectedDateRecordData(selectedDate)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToHomeDetailCount" {
            let destination = segue.destination as! HomeDetailViewController
            
            if let record = sender as? RecordMO {
                destination.record = record
            }
        } else if segue.identifier == "GoToHomeDetailML" {
            let destination = segue.destination as! HomeDetailMLViewController
            
            if let record = sender as? RecordMO {
                destination.record = record
            }
        }
    }
}

// MARK: - Actions
private extension HomeController {
    @IBAction func rightBarButtonItemTapped(_ sender: UIButton) {
        let previousDate = selectedDate
        if let currentSelectedDate = previousDate.addDay(1) {
            selectedDate = currentSelectedDate
        }
    }
    
    @IBAction func leftBarButtonItemTapped(_ sender: UIButton) {
        let previousDate = selectedDate
        if let currentSelectedDate = previousDate.addDay(-1) {
            selectedDate = currentSelectedDate
        }
    }
}

// MARK: - Setup UI
private extension HomeController {
    func setupTitle(_ date: Date) {
        if date.isToday {
            self.navigationItem.title = "Today"
        } else if date.isYesterday {
            self.navigationItem.title = "Yesterday"
        } else if date.isTomorrow {
            self.navigationItem.title = "Tomorrow"
        } else {
            self.navigationItem.title = date.toString("MMM dd")
        }
    }
    
    func checkAndSetRightBarButtonIsEnable(_ date: Date) {
        if date.isTomorrow {
            rightBarButtonItem.isEnabled = false
            rightBarButtonItem.tintColor = .clear
        } else {
            rightBarButtonItem.isEnabled = true
            rightBarButtonItem.tintColor = .primaryColor
        }
    }
    
    func filterCurrentSelectedDateRecordData(_ date: Date) {
        selectedDateUndoneRecord = []
        selectedDateDoneRecord = []
        
        for habit in habitData {
            var isHabitHasRecord = false
            
            for record in recordData {
                if selectedDate.toString() == record.date.toString() && habit == record.habit {
                    if record.isAchieve {
                        selectedDateDoneRecord.append(record)
                    } else {
                        selectedDateUndoneRecord.append(record)
                    }
                    isHabitHasRecord = true
                    break
                }
            }
            
            if !isHabitHasRecord {
                if let record = RecordMO.insertRecord(habit: habit, date: date) {
                    selectedDateUndoneRecord.append(record)
                }
            }
        }
    }
    
    func selectData() {
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let requestHabit: NSFetchRequest<HabitMO> = HabitMO.fetchRequest()
            let requestRecord: NSFetchRequest<RecordMO> = RecordMO.fetchRequest()
            
            let context = appDelegate.persistentContainer.viewContext
            
            do {
                habitData = try context.fetch(requestHabit)
                recordData = try context.fetch(requestRecord)
            } catch {
                showMessage(title: "Error", message: "Something went wrong!")
            }
        }
    }
}

extension HomeController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if habitData.isEmpty {
            homeTableView.backgroundView?.isHidden = false
            return 1
        } else {
            homeTableView.backgroundView?.isHidden = true
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return selectedDateUndoneRecord.count
        } else {
            return selectedDateDoneRecord.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HomeTableViewCell.self)) as? HomeTableViewCell else {
            return UITableViewCell()
        }
        
        let item = (indexPath.section == 0) ? selectedDateUndoneRecord[indexPath.row] : selectedDateDoneRecord[indexPath.row]
        
        cell.recordLabel.text = item.valueString
        cell.habitNameLabel.text = item.habit.name
        cell.percentLabel.text = item.percentString
        cell.icon.text = item.habit.icon
        cell.innerView.backgroundColor = (indexPath.section == 0) ? .lightGray : .primaryColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let record = (indexPath.section == 0) ? selectedDateUndoneRecord[indexPath.row] : selectedDateDoneRecord[indexPath.row]
        
        switch record.habit.unitTypeEnum {
        case .ml, .mins:
            self.performSegue(withIdentifier: "GoToHomeDetailML", sender: record)
        case .count:
            self.performSegue(withIdentifier: "GoToHomeDetailCount", sender: record)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section > 0 else { return "" }
        
        return (selectedDateDoneRecord.count > 0) ? "Completed" : ""
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (section == 0) ? 0 : 60
    }
}
