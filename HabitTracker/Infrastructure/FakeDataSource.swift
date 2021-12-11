import Foundation

enum FakeDataSourceError: Error {
    case recordIdIsNotExisted
    case habitIdIsNotExisted
}

class FakeDataSource {
    static let shared = FakeDataSource()
    
    var habitData: [Habit]
    var recordData: [Record]
    
    private init() {
        habitData = [
            Habit(id: UUID(), name: "Water", unitType: .ml, goal: 2000, icon: "💦"),
            Habit(id: UUID(), name: "Yoga", unitType: .mins, goal: 60, icon: "🧘🏻"),
            Habit(id: UUID(), name: "Eat Fruit", unitType: .count, goal: 3, icon: "🍎")
        ]

        recordData = [
            Record(id: UUID(), habit: habitData[0], value: 2000, date: Date()),
            Record(id: UUID(), habit: habitData[0], value: 2000, date: "2021-11-19".toDate()!),
            Record(id: UUID(), habit: habitData[1], value: 30, date: "2021-1-23".toDate()!),
            Record(id: UUID(), habit: habitData[1], value: 60, date: "2021-1-24".toDate()!),
            Record(id: UUID(), habit: habitData[1], value: 10, date: "2021-1-25".toDate()!),
            Record(id: UUID(), habit: habitData[1], value: 25, date: "2021-11-18".toDate()!),
            Record(id: UUID(), habit: habitData[1], value: 30, date: Date()),
            Record(id: UUID(), habit: habitData[2], value: 0, date: "2021-3-17".toDate()!),
            Record(id: UUID(), habit: habitData[2], value: 1, date: "2021-3-05".toDate()!),
            Record(id: UUID(), habit: habitData[2], value: 1, date: Date()),
            Record(id: UUID(), habit: habitData[2], value: 1, date: "2021-11-19".toDate()!)
        ]
    }
    
    // fetch record by id
    func fetchRecord(id: UUID) -> Record? {
        return recordData.first { $0.id == id }
    }
    
    func fetchHabit(id: UUID) -> Habit? {
        return habitData.first { $0.id == id }
    }
    
    func isHabitExisted(id: UUID) -> Bool {
        return fetchHabit(id: id) != nil
    }
    
    func isRecordExisted(id: UUID) -> Bool {
        return fetchRecord(id: id) != nil
    }
    
    // update record
    func updateRecord(record: Record) throws {
        if isRecordExisted(id: record.id) {
            // update
            if let index = recordData.firstIndex(where: { $0.id == record.id }) {
                recordData[index] = record
            } else {
                throw FakeDataSourceError.recordIdIsNotExisted
            }
        } else {
            throw FakeDataSourceError.recordIdIsNotExisted
        }
    }
    
    // updateHabit
    func updateHabit(habit: Habit) throws {
        if isHabitExisted(id: habit.id) {
            // update
            if let index = habitData.firstIndex(where: { $0.id == habit.id }) {
//                habitData[index] = habit
                habitData[index].name = habit.name
                habitData[index].icon = habit.icon
                habitData[index].goal = habit.goal
            } else {
                throw FakeDataSourceError.habitIdIsNotExisted
            }
        } else {
            throw FakeDataSourceError.habitIdIsNotExisted
        }
    }
    
    // insert record
    func insertRecord(habit: Habit, date: Date) -> Record {
        let tempRecord = Record(id: UUID(), habit: habit, value: 0, date: date)

        recordData.append(tempRecord)
        return tempRecord
    }
    
    //insert habit
    func insertHabit(habit: Habit) -> Bool {
        if habitData.firstIndex(where: { $0.id == habit.id }) != nil {
            return false
        } else {
            habitData.append(habit)
            return true
        }
    }
}
