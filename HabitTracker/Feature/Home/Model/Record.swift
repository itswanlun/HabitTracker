import Foundation

struct Record {
    let id: UUID
    let habit: Habit
    var value: Int
    let date: Date
    
    var isAchieve: Bool {
        value >= habit.goal
    }
}
