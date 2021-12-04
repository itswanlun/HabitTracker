import Foundation

struct Record {
    let id: UUID
    let habit: Habit
    let value: Int
    let date: Date
    
    var isAchieve: Bool {
        value >= habit.goal
    }
}
