import Foundation
import CoreData
import UIKit


extension HabitMO {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<HabitMO> {
        return NSFetchRequest<HabitMO>(entityName: "Habit")
    }

    @NSManaged public var goal: Int32
    @NSManaged public var icon: String
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var quickAdd1: Int32
    @NSManaged public var quickAdd2: Int32
    @NSManaged public var quickAdd3: Int32
    @NSManaged public var unitType: Int32

    var unitTypeEnum: GoalModeType {
        get { GoalModeType(rawValue: self.unitType) ?? .count }
        set { self.unitType = newValue.rawValue }
    }
    
    var quickAdd1Text: String {
        "\(quickAdd1) \(unitTypeEnum.unitText)"
    }
    
    var quickAdd2Text: String {
        "\(quickAdd2) \(unitTypeEnum.unitText)"
    }
    
    var quickAdd3Text: String {
        "\(quickAdd3) \(unitTypeEnum.unitText)"
    }
}

extension HabitMO : Identifiable {}

extension HabitMO {
    static func insertHabit(name: String, unitType: GoalModeType, goal: Int, icon: String) -> Bool {
        guard let appDelegate = (UIApplication.shared.delegate as? AppDelegate) else { return false }
        
        let habit = HabitMO(context: appDelegate.persistentContainer.viewContext)
        habit.id = UUID()
        habit.unitTypeEnum = unitType
        habit.name = name
        habit.goal = Int32(goal)
        habit.icon = icon
        
        switch unitType {
        case .count:
            habit.quickAdd1 = 0
            habit.quickAdd2 = 0
            habit.quickAdd3 = 0
        case .mins:
            habit.quickAdd1 = 5
            habit.quickAdd2 = 10
            habit.quickAdd3 = 15
        case .ml:
            habit.quickAdd1 = 360
            habit.quickAdd2 = 500
            habit.quickAdd3 = 1000
        }
        
        appDelegate.saveContext()
        
        return true
    }
    
    static func fetchHabitbyId(id: UUID) -> HabitMO? {
        guard let appDelegate = (UIApplication.shared.delegate as? AppDelegate) else { return nil }
        
        let requestHabit: NSFetchRequest<HabitMO> = HabitMO.fetchRequest()
        let context = appDelegate.persistentContainer.viewContext
        
        requestHabit.predicate = NSPredicate(format: "%K == %@", "id", id as NSObject)
        
        do {
            let habitDatas = try context.fetch(requestHabit)
            return habitDatas[0]
        } catch {
            print("Failed to fetch")
            return nil
        }
    }
    
    static func updateHabit(id: UUID, name: String, unitType: GoalModeType, goal: Int, icon: String, quickAdd1: Int, quickAdd2: Int, quickAdd3: Int) throws {
        guard let appDelegate = (UIApplication.shared.delegate as? AppDelegate) else { return }
        
        let request: NSFetchRequest<HabitMO> = HabitMO.fetchRequest()
        let context = appDelegate.persistentContainer.viewContext
        
        request.predicate = NSPredicate(format: "%K == %@", "id", id as NSObject)
        
        do {
            let results = try context.fetch(request)
            if let result = results.first {
                result.name = name
                result.unitTypeEnum = unitType
                result.goal = Int32(goal)
                result.icon = icon
                result.quickAdd1 = Int32(quickAdd1)
                result.quickAdd2 = Int32(quickAdd2)
                result.quickAdd3 = Int32(quickAdd3)
                
                try context.save()
            }
        } catch {
            print("Failed to update: fetchError")
        }
    }
    
    static func deleteAllData() {
        guard let appDelegate = (UIApplication.shared.delegate as? AppDelegate) else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        let requestRecord = HabitMO.fetchRequest()
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
    
    static func deleteHabit(id: UUID) {
        guard let appDelegate = (UIApplication.shared.delegate as? AppDelegate) else { return }
        
        let request: NSFetchRequest<HabitMO> = HabitMO.fetchRequest()
        let context = appDelegate.persistentContainer.viewContext
        
        request.predicate = NSPredicate(format: "%K == %@", "id", id as NSObject)
        
        do {
            let results = try context.fetch(request)
            if let result = results.first {
                try context.delete(result)
                try context.save()
            }
        } catch {
            print("Failed to update: fetchError")
        }
    }
}
