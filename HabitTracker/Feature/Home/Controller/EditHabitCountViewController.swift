//
//  EditHabitCountViewController.swift
//  HabitTracker
//
//  Created by Wan-lun Zheng on 2021/12/9.
//

import UIKit

class EditHabitCountViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var habitNameTextField: UITextField!
    @IBOutlet weak var goalModeButton: UIButton!
    @IBOutlet weak var iconButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var record: Record?
    var goal: Int? = 1
    var icon: String?
    var unitType: GoalModeType? = .count
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        goalModeButton.layer.cornerRadius = 5
        goalModeButton.tintColor = UIColor.mainBlack
        setupUI()
        
        if let record = record {
            fetchDataFromDB(id: record.id)
        }
    }
    
    func fetchDataFromDB(id: UUID) {
        let record = FakeDataSource.shared.fetchRecord(id: id)
        self.record = record
        self.goal = record?.habit.goal
        self.icon = record?.habit.icon
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier  == "EditCountGoToGoalMode" {
            let destination = segue.destination as! EditHabitGoalModeViewController
            destination.delegate = self
            destination.record = record
        } else if segue.identifier == "EditCountGoToIcon" {
            let destinationIcon = segue.destination as! EditHabitIconViewController
            destinationIcon.delegate = self
        }
    }
    
    
    
    // MARK: - IBAction
    @IBAction func goalModeButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "EditCountGoToGoalMode", sender: record)
    }
    
    @IBAction func iconButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "EditCountGoToIcon", sender: self)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        guard let goal = goal else {
            showMessage(title: "Warning", message: "Please fill out the goal")
            return
        }

        guard let unitType = unitType else {
            showMessage(title: "Warning", message: "Please fill out the unit")
            return
        }

        guard let icon = icon else {
            showMessage(title: "Warning", message: "Please select an icon")
            return
        }

        guard let habitname = habitNameTextField.text else {
            showMessage(title: "Warning", message: "Please enter habit name")
            return
        }

        if let record = record {
            let habit = Habit(id: record.habit.id, name: habitname, unitType: unitType, goal: goal, icon: icon)
            
            do {
                try FakeDataSource.shared.updateHabit(habit: habit)
                
                self.navigationController?.popToRootViewController(animated: true)
            } catch {
                print("👠")
            }
        }
    }
    
    private func showMessage(title: String? = nil, message: String? = nil) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(okAction)
        
        present(controller, animated: true, completion: nil)
    }
}

// MARK: - Setup UI
extension EditHabitCountViewController {
    private func setupUI() {
        if let record = record {
            habitNameTextField.text = record.habit.name
            goalModeButton.setTitle("\(record.habit.goal) \(record.habit.unitType)", for: .normal)
            iconButton.setTitle("\(record.habit.icon)", for: .normal)
        }
    }
}


extension EditHabitCountViewController: EditHabitGoalModeViewControllerDelegate {
    func goalMode(_ viewController: EditHabitGoalModeViewController, receivedUnit unit: GoalModeType, reveovedGoal goal: Int) {
        self.goal = goal
        self.unitType = unit

        goalModeButton.setTitle("\(goal) \(unit)", for: .normal)
    }
}

extension EditHabitCountViewController: EditHabitIconViewControllerDelegate {
    func Icon(_ viewController: EditHabitIconViewController, receivedIcon icon: String) {
        print(icon)
        self.icon = icon
        iconButton.setTitle("\(icon)", for: .normal)
    }
}
