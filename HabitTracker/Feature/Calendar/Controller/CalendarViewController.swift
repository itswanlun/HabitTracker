//
//  CalendarViewController.swift
//  HabitTracker
//
//  Created by Wan-lun Zheng on 2021/10/24.
//

import UIKit
import JTAppleCalendar

class CalendarViewController: UIViewController {

    @IBOutlet weak var habitListStackView: UIStackView!
    @IBOutlet weak var calendarCollectionView: JTACMonthView!
    @IBOutlet weak var monthLabel: UILabel!
    let formatter = DateFormatter()
    private(set) var selectedHabit: Int = 0
    var buttonArr: [UIButton] = [UIButton]()
    var selectedHabitData: [Record] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarCollectionView.visibleDates() { visibleDates in
            self.setupMonthLabel(date: visibleDates.monthDates.first!.date)
        }
        
        calendarCollectionView.allowsMultipleSelection = true
        appendHabit()
        selectRecordData(buttonindex: 0)
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
                //cell.selectedView.layer.cornerRadius = 20
                cell.selectedView.backgroundColor = .lightGray
                break
            } else {
                //cell.selectedView.layer.cornerRadius = 20
                cell.selectedView.backgroundColor = .white
            }
        }
    }
    
    func selectRecordData(buttonindex: Int) {
        selectedHabitData = []
        let habit = FakeDataSource.shared.habitData[buttonindex]
        for record in FakeDataSource.shared.recordData {
            if habit.id == record.habit.id {
                selectedHabitData.append(record)
            }
        }
    }
    
    func handleCellColor(cell: CalendarCollectionViewCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            cell.dateLabel.textColor = .black
            cell.isSelected = true
            
        } else {
            cell.dateLabel.textColor = .gray
        }
    }
    
    func appendHabit() {
//        let habitView = UIView()
//        habitView.heightAnchor.constraint(equalToConstant: 100).isActive = true
//        habitView.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        habitView.backgroundColor = .brown

        
        for (index, record) in FakeDataSource.shared.habitData.enumerated() {
            
            let habitButton = UIButton()
            habitButton.setTitle(record.icon, for: .normal)
            habitButton.layer.cornerRadius = 10
            habitButton.addTarget(self, action: #selector(habitButtonTapped), for: .touchUpInside)
            habitButton.tag = index
            habitButton.titleLabel?.font = .systemFont(ofSize: 50)
            habitButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
            habitButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
            
            //selectRecordData(buttonindex: habitButton.tag)
            
            buttonArr.append(habitButton)
            
            if selectedHabit == index {
                habitButton.backgroundColor = .lightGray
            }
            
//            let lbl = UILabel()
//            lbl.text = index.Icon
//            lbl.font = UIFont(name: "Helvetica-Light", size: 50)
//            lbl.heightAnchor.constraint(equalToConstant: 100).isActive = true
//            lbl.widthAnchor.constraint(equalToConstant: 100).isActive = true
            //lbl.backgroundColor = .red
            
            habitListStackView.addArrangedSubview(habitButton)
        }
    }
    
    @objc func habitButtonTapped(_ sender: UIButton) {
//        buttonArr[selectedHabit].backgroundColor = .white
//        selectedHabit = sender.tag
//        buttonArr[selectedHabit].backgroundColor = .lightGray
        let previousIndex = selectedHabit
        let previousHabitData = selectedHabitData
        
        selectedHabit = sender.tag
        buttonArr[previousIndex].backgroundColor = .white
        buttonArr[selectedHabit].backgroundColor = .lightGray
        selectRecordData(buttonindex: sender.tag)
        
        calendarCollectionView.reloadDates(previousHabitData.map { $0.date } + selectedHabitData.map { $0.date })
    }
}

extension CalendarViewController: JTACMonthViewDataSource, JTACMonthViewDelegate {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        
        let startDate = formatter.date(from: "2021 01 01")!
        let endDate = formatter.date(from: "2021 12 31")!
        
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
