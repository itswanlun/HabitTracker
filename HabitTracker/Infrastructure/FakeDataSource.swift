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
            Habit(id: UUID(), name: "Water", unitType: "ML", goal: 2000, icon: "💦", color: "", quickAdd1: 200, quickAdd2: 300, quickAdd3: 500, quickAdd4: 600),
            Habit(id: UUID(), name: "Yoga", unitType: "Mins", goal: 60, icon: "🧘🏻", color: "", quickAdd1: 10, quickAdd2: 30, quickAdd3: 40, quickAdd4: 60),
            Habit(id: UUID(), name: "Eat Fruit", unitType: "Count", goal: 3, icon: "🍎", color: "", quickAdd1: 0, quickAdd2: 0, quickAdd3: 0, quickAdd4: 0)
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
}
