import UIKit
import JTAppleCalendar
import CoreData

class CalendarViewController: UIViewController {
    @IBOutlet weak var habitScrollView: UIScrollView!
    @IBOutlet weak var habitListStackView: UIStackView!
    @IBOutlet weak var habitLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var weekStackView: UIStackView!
    @IBOutlet weak var calendarCollectionView: JTACMonthView!
    @IBOutlet weak var completedLabelContainer: UIView!
    
    let formatter = DateFormatter()
    let emptyImageView = UIImageView(frame: .zero)
    
    var buttonArr: [UIButton] = [UIButton]()
    var selectedHabitData: [RecordMO] = []
    var habitData: [HabitMO] = []
    var recordData: [RecordMO] = []
    
    private(set) var selectedHabit: Int = 0
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupEmptyView()
        selectData()
        
        calendarCollectionView.visibleDates() { visibleDates in
            self.setupMonthLabel(date: visibleDates.monthDates.first!.date)
        }
        
        calendarCollectionView.allowsMultipleSelection = true
        calendarCollectionView.scrollToDate(Date(), animateScroll: false)
        calendarCollectionView.showsHorizontalScrollIndicator = false
        calendarCollectionView.showsVerticalScrollIndicator = false
        habitScrollView.showsHorizontalScrollIndicator = false
        habitScrollView.showsVerticalScrollIndicator = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        selectData()
        appendHabit()
        if habitData.count > 0 {
            emptyImageView.isHidden = true
            monthLabel.isHidden = false
            habitLabel.isHidden = false
            weekStackView.isHidden = false
            calendarCollectionView.isHidden = false
            completedLabelContainer.isHidden = false
            
            selectRecordData(buttonindex: 0)
        }else {
            monthLabel.isHidden = true
            habitLabel.isHidden = true
            weekStackView.isHidden = true
            calendarCollectionView.isHidden = true
            completedLabelContainer.isHidden = true
            emptyImageView.isHidden = false
        }
    }
}

// MARK: - Actions
extension CalendarViewController {
    @objc func habitButtonTapped(_ sender: UIButton) {
        let previousIndex = selectedHabit
        let previousHabitData = selectedHabitData
        
        selectedHabit = sender.tag
        buttonArr[previousIndex].backgroundColor = .white
        buttonArr[selectedHabit].backgroundColor = .primaryColor
        habitLabel.text = habitData[sender.tag].name
        selectRecordData(buttonindex: sender.tag)
        
        calendarCollectionView.reloadDates(previousHabitData.map { $0.date } + selectedHabitData.map { $0.date })
    }
    
    func appendHabit() {
        buttonArr = []
        habitListStackView.removeAllArrangedSubviews()
        for (index, record) in habitData.enumerated() {
            let habitButton = UIButton()
            habitButton.setTitle(record.icon, for: .normal)
            habitButton.layer.cornerRadius = 10
            habitButton.addTarget(self, action: #selector(habitButtonTapped), for: .touchUpInside)
            habitButton.tag = index
            habitButton.titleLabel?.font = .systemFont(ofSize: 40)
            habitButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
            habitButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
            
            buttonArr.append(habitButton)
            
            if selectedHabit == index {
                habitButton.backgroundColor = .primaryColor
                habitLabel.text = habitData[selectedHabit].name
            }
            
            habitListStackView.addArrangedSubview(habitButton)
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
    
    func selectRecordData(buttonindex: Int) {
        selectedHabitData = []
        let habit = habitData[buttonindex]
        for record in recordData {
            if habit.id == record.habit.id {
                selectedHabitData.append(record)
            }
        }
    }
}

// MARK: - Setup UI
private extension CalendarViewController {
    func setupEmptyView() {
        emptyImageView.translatesAutoresizingMaskIntoConstraints = false
        emptyImageView.isHidden = true
        emptyImageView.image = UIImage(named: "empty")
        
        view.addSubview(emptyImageView)
        
        NSLayoutConstraint.activate([
            emptyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyImageView.widthAnchor.constraint(equalToConstant: 300),
            emptyImageView.heightAnchor.constraint(equalTo: emptyImageView.widthAnchor, multiplier: 141/381)
        ])
    }
    
    func setupMonthLabel(date: Date) {
        formatter.dateFormat = "MMMM Y"
        monthLabel.text = formatter.string(from: date)
    }
    
    func handleConfiguration(cell: JTACDayCell?, cellState: CellState) {
        guard let cell = cell as? CalendarCollectionViewCell else { return }
        handleCellColor(cell: cell, cellState: cellState)
        handleCellSelection(cell: cell, cellState: cellState)
    }
    
    func handleCellSelection(cell: CalendarCollectionViewCell, cellState: CellState) {
        let cellDateString = cellState.date.toString()
        
        for record in selectedHabitData {
            let recordDateString = record.date.toString()
            if record.isAchieve && recordDateString == cellDateString {
                cell.selectedView.backgroundColor = .primaryColor
                break
            } else {
                cell.selectedView.backgroundColor = .white
            }
        }
    }
    
    func handleCellColor(cell: CalendarCollectionViewCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            cell.dateLabel.textColor = .textColor
            cell.isSelected = true
            
        } else {
            cell.dateLabel.textColor = .gray
        }
    }
}

extension CalendarViewController: JTACMonthViewDataSource, JTACMonthViewDelegate {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        
        let startDate = formatter.date(from: "2000 01 01")!
        let endDate = formatter.date(from: "2100 12 31")!
        
        let parameter = ConfigurationParameters(startDate: startDate,
                                                endDate: endDate,
                                                numberOfRows: 6,
                                                generateInDates: .forAllMonths,
                                                generateOutDates: .tillEndOfRow,
                                                firstDayOfWeek: .sunday)
        return parameter
    }
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! CalendarCollectionViewCell
        cell.dateLabel.text = cellState.text
        
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        
        return cell
    }
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        handleConfiguration(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        if let date = visibleDates.monthDates.first?.date {
            setupMonthLabel(date: date)
        }
    }
}
