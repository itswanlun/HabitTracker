import UIKit
import CoreData

class HomeController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var rightBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var leftBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var homeTableView: UITableView!
    
    var habitData: [HabitMO] = []
    var recordData: [RecordMO] = []
    
    var selectedDateUndoneRecord: [RecordMO] = [] {
        didSet {
            homeTableView.reloadData()
        }
    }
    
    var selectedDateDoneRecord: [RecordMO] = [] {
        didSet {
            homeTableView.reloadData()
        }
    }
    
    var selectedDate = Date() {
        didSet {
            setupTitle(selectedDate)
            checkAndSetRightBarButtonIsEnable(selectedDate)
            filterCurrentSelectedDateRecordData(selectedDate)
        }
    }
    
    // MARK: - IBAction
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
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Today"
        selectData()
        filterCurrentSelectedDateRecordData(selectedDate)
        
//        FakeDataSource.shared.habitData[2] = Habit(id: UUID(), name: "Eat Fruit", unitType: .count, goal: 66, icon: "🐵")
//        print(FakeDataSource.shared.recordData)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier  == "GoToHomeDetailCount" {
            let destination = segue.destination as! HomeDetailViewController
            
            if let record = sender as? RecordMO {
                destination.record = record
            }
        } else if segue.identifier  == "GoToHomeDetailML" {
            let destination = segue.destination as! HomeDetailMLViewController
            
            if let record = sender as? RecordMO {
                destination.record = record
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        selectData()
        filterCurrentSelectedDateRecordData(selectedDate)
    }
}

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
            rightBarButtonItem.tintColor = .systemBlue
        }
    }

    func filterCurrentSelectedDateRecordData(_ date: Date) {
        selectedDateUndoneRecord = []
        selectedDateDoneRecord = []

        for habit in habitData {
            var isHabitHasRecord = false
            for record in recordData {
                if selectedDate == record.date && habit == record.habit {
                    if record.isAchieve {
                        selectedDateDoneRecord.append(record)
                    } else {
                        selectedDateUndoneRecord.append(record)
                    }
                    isHabitHasRecord = true
                    break
                }
            }

//            if isHabitHasRecord == false {
//                if let record = RecordMO.insertRecord(habit: habit, date: date) {
//                    selectedDateUndoneRecord.append(record)
//                }
//            }
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
                
//                HabitMO.deleteAllData()
//                RecordMO.deleteAllData()
                
                print(habitData)
                print("-------------------\n")
                print(recordData)
            } catch {
                print("Failed to fetch")
            }
        }
    }
}

extension HomeController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return selectedDateUndoneRecord.count
        } else {
            return selectedDateDoneRecord.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HomeUITableViewCell.self)) as? HomeUITableViewCell else {

                return UITableViewCell()
            }

            let item = selectedDateUndoneRecord[indexPath.row]

            let percent = Int((Float(item.value)/Float(item.habit.goal)) * 100)

            cell.HabitName.text = "\(item.habit.name)"
            cell.Record.text = "\(item.value)"
            cell.Percent.text = "\(percent) %"
            cell.icon.text = "\(item.habit.icon)"

            //        if let url = URL(string: item.habit.icon) {
            //            cell.IconImageView.setImage(url :url)
            //        }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HomeUITableViewCell.self)) as? HomeUITableViewCell else {

                return UITableViewCell()
            }

            let item = selectedDateDoneRecord[indexPath.row]

            let percent = Int((Float(item.value)/Float(item.habit.goal)) * 100)

            cell.HabitName.text = "\(item.habit.name)"
            cell.Record.text = "\(item.value)"
            cell.Percent.text = "\(percent) %"
            cell.icon.text = "\(item.habit.icon)"

            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let record: RecordMO
        if indexPath.section == 0 {
            record = selectedDateUndoneRecord[indexPath.row]
        } else {
            record = selectedDateDoneRecord[indexPath.row]
        }

        switch record.habit.unitTypeEnum {
        case .ml, .mins:
            self.performSegue(withIdentifier: "GoToHomeDetailML", sender: record)
        case .count:
            self.performSegue(withIdentifier: "GoToHomeDetailCount", sender: record)
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return ""
        } else {
            return "Completed"
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 60
        }
    }
}
