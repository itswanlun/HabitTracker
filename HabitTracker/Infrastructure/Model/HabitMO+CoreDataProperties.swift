//
//  HabitMO+CoreDataProperties.swift
//  HabitTracker
//
//  Created by Wan-lun Zheng on 2021/12/14.
//
//

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
            
            requestHabit.predicate = nil
            let updateID = id
            requestHabit.predicate = NSPredicate(format: "id == '\(updateID)'")

            do {
                let habitDatas = try context.fetch(requestHabit)
                return habitDatas[0]
            } catch {
                print("Failed to fetch")
                return nil
            }
    }
    
    static func updateHabit(id: UUID, name: String, unitType: GoalModeType, goal: Int, icon: String) throws {
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let request: NSFetchRequest<HabitMO> = HabitMO.fetchRequest()
            let context = appDelegate.persistentContainer.viewContext
            
            request.predicate = nil
            let updateID = id
            request.predicate = NSPredicate(format: "id == '\(updateID)'")
            
            do {
                var results = try context.fetch(request)
                results[0].id = id
                results[0].name = name
                results[0].unitTypeEnum = unitType
                results[0].goal = Int32(goal)
                results[0].icon = icon
                
                do {
                    try context.save()
                    print(results[0])
                } catch {
                    print("Failed to update: createError")
                }
                
            } catch {
                print("Failed to update: fetchError")
            }
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
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
}
