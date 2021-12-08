import Foundation

enum FakeDataSourceError: Error {
    case recordIdIsNotExisted
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
            Record(id: UUID(), habit: habitData[0], value: 2000, date: Date(), history: [500, 500, 500, 500]),
            Record(id: UUID(), habit: habitData[0], value: 2000, date: "2021-11-19".toDate()!, history: [1000, 1000]),
            Record(id: UUID(), habit: habitData[1], value: 30, date: "2021-1-23".toDate()!, history: [30]),
            Record(id: UUID(), habit: habitData[1], value: 60, date: "2021-1-24".toDate()!, history: [30, 30]),
            Record(id: UUID(), habit: habitData[1], value: 10, date: "2021-1-25".toDate()!, history: [10]),
            Record(id: UUID(), habit: habitData[1], value: 25, date: "2021-11-18".toDate()!, history: [20, 5]),
            Record(id: UUID(), habit: habitData[1], value: 30, date: Date(), history: [10 , 10 , 10]),
            Record(id: UUID(), habit: habitData[2], value: 0, date: "2021-3-17".toDate()!, history: []),
            Record(id: UUID(), habit: habitData[2], value: 1, date: "2021-3-05".toDate()!, history: []),
            Record(id: UUID(), habit: habitData[2], value: 1, date: Date(), history: []),
            Record(id: UUID(), habit: habitData[2], value: 1, date: "2021-11-19".toDate()!, history: [])
        ]
    }
    
    // fetch record by id
    func fetchRecord(id: UUID) -> Record? {
        return recordData.first { $0.id == id }
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
    
    // insert record
    func insertRecord(habit: Habit) {
        let tempRecord = Record(id: UUID(), habit: habit, value: 0, date: Date(), history: [])
        
        recordData.append(tempRecord)
    }
    
    //insert habit
    func insertHabit(habit: Habit) -> Bool {
        if habitData.firstIndex(where: { $0.id == habit.id }) != nil {
            return false
        } else {
            habitData.append(habit)
            insertRecord(habit: habit)
            return true
        }
    }
}
