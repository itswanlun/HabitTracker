import Foundation
import UIKit

protocol HabitStrategy {
    var habitID: UUID? { get }
    
    func isCancelButtonHidden() -> Bool
    func isGoalTypeEnable() -> Bool
    func isQuickActiosHidden() -> Bool
}

class CreateHabitStrategy: HabitStrategy {
    let habitID: UUID? = nil
    
    func isCancelButtonHidden() -> Bool {
        return false
    }
    
    func isGoalTypeEnable() -> Bool {
        return true
    }
    
    func isQuickActiosHidden() -> Bool {
        return true
    }
}

class EditHabitStrategy: HabitStrategy {
    let habitID: UUID?
    let unit: GoalModeType
    
    init(habitID: UUID, unit: GoalModeType) {
        self.habitID = habitID
        self.unit = unit
    }
    
    func isCancelButtonHidden() -> Bool {
        return true
    }
    
    func isGoalTypeEnable() -> Bool {
        return false
    }
    
    func isQuickActiosHidden() -> Bool {
        switch unit {
        case .ml:
            return false
        case .mins:
            return false
        case .count:
            return true
        }
    }
}
