import UIKit

var habitData: [Habit] = [
    Habit(id: UUID(), name: "Water", unitType: "Mal", goal: 2000, icon: "💦", color: "", quickAdd1: 200, quickAdd2: 300, quickAdd3: 500, quickAdd4: 600),
    Habit(id: UUID(), name: "Yoga", unitType: "Mins", goal: 60, icon: "🧘🏻", color: "", quickAdd1: 10, quickAdd2: 30, quickAdd3: 40, quickAdd4: 60),
    Habit(id: UUID(), name: "Eat Fruit", unitType: "Count", goal: 1, icon: "🍎", color: "", quickAdd1: 0, quickAdd2: 0, quickAdd3: 0, quickAdd4: 0)
    ]

var recordData: [Record] = [
    Record(id: UUID(), habit: habitData[0], value: 2000, date: Date()),
    Record(id: UUID(), habit: habitData[0], value: 2000, date: "2021-11-19".toDate()!),
    Record(id: UUID(), habit: habitData[1], value: 666660, date: "2021-1-23".toDate()!),
    Record(id: UUID(), habit: habitData[1], value: 666660, date: "2021-1-24".toDate()!),
    Record(id: UUID(), habit: habitData[1], value: 666660, date: "2021-1-25".toDate()!),
    Record(id: UUID(), habit: habitData[1], value: 666660, date: "2021-11-18".toDate()!),
    Record(id: UUID(), habit: habitData[1], value: 666660, date: Date()),
    Record(id: UUID(), habit: habitData[2], value: 1, date: "2021-3-17".toDate()!),
    Record(id: UUID(), habit: habitData[2], value: 1, date: "2021-3-05".toDate()!),
    Record(id: UUID(), habit: habitData[2], value: 1, date: Date()),
    Record(id: UUID(), habit: habitData[2], value: 1, date: "2021-11-19".toDate()!)
]

class HomeController: UIViewController {
    
    @IBOutlet weak var rightBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var leftBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var homeTableView: UITableView!
    var selectedDateRecord: [Record] = [] {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Today"
        filterCurrentSelectedDateRecordData(selectedDate)
    }
}

private extension HomeController {
    func setupTitle(_ date: Date) {
        if date.isToday {
            title = "Today"
        } else if date.isYesterday {
            title = "Yesterday"
        } else if date.isTomorrow {
            title = "Tomorrow"
        } else {
            title = date.toString("MMM dd")
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
        selectedDateRecord = []
        for record in recordData {
            if selectedDate.toString() == record.date.toString() {
                selectedDateRecord.append(record)
            }
        }
    }
}

extension HomeController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedDateRecord.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HomeUITableViewCell.self)) as? HomeUITableViewCell else {

            return UITableViewCell()
        }
        
        let item = selectedDateRecord[indexPath.row]
        
        let percent = Int((Float(item.value)/Float(item.habit.goal)) * 100)
        
        cell.HabitName.text = "\(item.habit.name)"
        cell.Record.text = "\(item.value)"
        cell.Percent.text = "\(percent) %"
        cell.icon.text = "\(item.habit.icon)"
        
//        if let url = URL(string: item.habit.icon) {
//            cell.IconImageView.setImage(url :url)
//        }
        return cell
    }
}
