import Foundation
import UIKit
import CoreData


extension RecordMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecordMO> {
        return NSFetchRequest<RecordMO>(entityName: "Record")
    }

    @NSManaged public var date: Date
    @NSManaged public var id: UUID
    @NSManaged public var value: Int32
    @NSManaged public var habit: HabitMO
    
    var isAchieve: Bool {
        value >= habit.goal
    }
}

extension RecordMO : Identifiable {}

extension RecordMO {
    static func insertRecord(habit: HabitMO, date: Date) -> RecordMO? {
        guard let appDelegate = (UIApplication.shared.delegate as? AppDelegate) else { return nil }
        
        let record = RecordMO(context: appDelegate.persistentContainer.viewContext)
        record.id = UUID()
        record.date = date
        record.value = 0
        record.habit = habit
        
        appDelegate.saveContext()
        
        return record
    }
    
    static func fetchRecord(id: UUID) -> RecordMO? {
        guard let appDelegate = (UIApplication.shared.delegate as? AppDelegate) else { return nil }

        let requestRecord: NSFetchRequest<RecordMO> = RecordMO.fetchRequest()
        let context = appDelegate.persistentContainer.viewContext
            
        requestRecord.predicate = NSPredicate(format: "id == '\(id)'")
        
        do {
            let recordDatas = try context.fetch(requestRecord)
            return recordDatas[0]
        } catch {
            print("Failed to fetch")
            return nil
        }
    }
    
    static func updateRecord(record: RecordMO) throws {
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let request: NSFetchRequest<RecordMO> = RecordMO.fetchRequest()
            let context = appDelegate.persistentContainer.viewContext
            
            print("🏈", record)
            
            request.predicate = NSPredicate(format: "id == '\(record.id)'")
            
            do {
                let results = try context.fetch(request)
                if results.first != nil {
                    results[0].id = record.id
                    results[0].date = record.date
                    results[0].value = record.value
                    results[0].habit = record.habit
                    
                    do {
                        try context.save()
                        print(results[0])
                    } catch {
                        print("Failed to update: createError")
                    }
                }
            } catch {
                print("Failed to update: fetchError")
            }
       }
    }
    
    static func deleteAllData() {
        guard let appDelegate = (UIApplication.shared.delegate as? AppDelegate) else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        let requestRecord = RecordMO.fetchRequest()
        requestRecord.returnsObjectsAsFaults = false

        do {
            let recordDatas = try context.fetch(requestRecord)
            for managedObject in recordDatas {
                let managedObjectData: NSManagedObject = managedObject as NSManagedObject
                context.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
}
