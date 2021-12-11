import Foundation

class Habit {
    let id: UUID
    var name: String
    var unitType: GoalModeType
    var goal: Int
    var icon: String
    var quickAdd1: Int
    var quickAdd2: Int
    var quickAdd3: Int
    var quickAdd4: Int
    
    init(id: UUID, name: String, unitType: GoalModeType, goal: Int, icon: String) {
        self.id = id
        self.name = name
        self.unitType = unitType
        self.goal = goal
        self.icon = icon
        
        switch unitType {
        case .count:
            self.quickAdd1 = 0
            self.quickAdd2 = 0
            self.quickAdd3 = 0
            self.quickAdd4 = 0
        case .mins:
            self.quickAdd1 = 5
            self.quickAdd2 = 10
            self.quickAdd3 = 15
            self.quickAdd4 = 20
        case .ml:
            self.quickAdd1 = 360
            self.quickAdd2 = 500
            self.quickAdd3 = 1000
            self.quickAdd4 = 2000
        }
    }
}

extension Habit: CustomStringConvertible {
    var description: String {
        " - \(id)\n - \(name)\n - \(unitType.text)\n - \(goal)\n - \(icon)\n"
    }
}
