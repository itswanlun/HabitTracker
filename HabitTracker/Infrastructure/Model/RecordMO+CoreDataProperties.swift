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

        let request = RecordMO.fetchRequest()
        let context = appDelegate.persistentContainer.viewContext
            
        request.predicate = NSPredicate(format: "%K == %@", "id", id as NSObject)
        
        do {
            let results = try context.fetch(request)
            return results.first
        } catch {
            print("Failed to fetch")
            return nil
        }
    }
    
    static func fetchAllRecords() -> [RecordMO] {
        guard let appDelegate = (UIApplication.shared.delegate as? AppDelegate) else { return [] }
        
        let requestRecord: NSFetchRequest<RecordMO> = RecordMO.fetchRequest()
        let context = appDelegate.persistentContainer.viewContext

        do {
            let recordData = try context.fetch(requestRecord)
            return recordData
        } catch {
            print("Failed to fetch")
            return []
        }
    }
    
    static func updateRecord(record: RecordMO) throws {
        guard let appDelegate = (UIApplication.shared.delegate as? AppDelegate) else { return }
        
//        let request = RecordMO.fetchRequest()
        let context = appDelegate.persistentContainer.viewContext
        
//        request.predicate = NSPredicate(format: "%K == %@", "id", record.id as NSObject)
        
        do {
//            let results = try context.fetch(request)
//            if let result = results.first {
//                result.value = record.value
                
                try context.save()
//            }
        } catch {
            print("Failed to update: fetchError")
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
            try context.save()
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
    
    static func deleteRecord(id: UUID) -> Bool {
        guard let appDelegate = (UIApplication.shared.delegate as? AppDelegate) else { return false }
        
        let request: NSFetchRequest<RecordMO> = RecordMO.fetchRequest()
        let context = appDelegate.persistentContainer.viewContext
        
        request.predicate = NSPredicate(format: "%K == %@", "habit.id", id as NSObject)
        
        do {
            let results = try context.fetch(request)
            for result in results {
                context.delete(result)
            }
            try context.save()
            return true
        } catch {
            print("Failed to update: fetchError")
            return false
        }
    }
}
