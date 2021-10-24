//
//  HomeConytroller.swift
//  HabitTracker
//
//  Created by Bing Kuo on 2021/10/16.
//

import UIKit

class HomeController: UIViewController {
    
    @IBOutlet weak var rightBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var leftBarButtonItem: UIBarButtonItem!
    
    @IBAction func rightBarButtonItemTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func leftBarButtonItemTapped(_ sender: UIButton) {
        
    }
    //    var Habitdata: [Habit] = [
//        Habit(id: UUID(), HabitName: "Water", UnitType: "Mal", Goal: 2000, Icon: "", Color: "", QuickAdd1: 360, QuickAdd2: 500, QuickAdd3: 600, QuickAdd4: 1000),
//        Habit(id: UUID(), HabitName: "Yoga", UnitType: "Mins", Goal: 60, Icon: "", Color: "", QuickAdd1: 10, QuickAdd2: 30, QuickAdd3: 40, QuickAdd4: 60),
//        Habit(id: UUID(), HabitName: "Eat Fruit", UnitType: "Count", Goal: 1, Icon: "", Color: "", QuickAdd1: 0, QuickAdd2: 0, QuickAdd3: 0, QuickAdd4: 0)
//    ]
    
    var habitRecorddata: [Record] = [
        Record(id: UUID(), HabitName: "Water", UnitType: "Mal", Goal: 2000, Record: 500, Icon: "https://via.placeholder.com/600/92c952", Color: ""),
        Record(id: UUID(), HabitName: "Yoga", UnitType: "Mins", Goal: 60, Record: 30, Icon: "https://via.placeholder.com/600/92c952", Color: ""),
        Record(id: UUID(), HabitName: "Eat Fruit", UnitType: "Count", Goal: 1, Record: 0, Icon: "https://via.placeholder.com/600/92c952", Color: "")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}


extension HomeController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habitRecorddata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HomeUITableViewCell.self)) as? HomeUITableViewCell else {

            return UITableViewCell()
        }
        
        let item = habitRecorddata[indexPath.row]
        
        let percent = Int((Float(item.Record)/Float(item.Goal)) * 100)
        
        cell.HabitName.text = "\(item.HabitName)"
        cell.Record.text = "\(item.Record)"
        cell.Percent.text = "\(percent) %"
        
        if let url = URL(string: item.Icon) {
            cell.IconImageView.setImage(url :url)
        }
        return cell
    }
}
