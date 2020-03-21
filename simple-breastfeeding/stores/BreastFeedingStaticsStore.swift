//
//  BreastShotStore.swift
//  rememberbreast
//
//  Created by Rodrigo Villamil Pérez on 19/7/18.
//  Copyright © 2018 Rodrigo Villamil Pérez. All rights reserved.
//
import CoreData
import Foundation
import UIKit

// https://medium.com/kkempin/coredata-basics-xcode-9-swift-4-56a0fc1d40cb
// https://github.com/filipemsmartins/MyTasks/blob/master/MyTasks/ViewController.swift
class BreastFeedingStaticsStore {
    
    // MARK: - Internal vars
    var breastFeedingStatics:  NSEntityDescription!     = nil
    var managedObjectContext : NSManagedObjectContext!  = nil
    // MARK: - Internal Constants
    let entityName="BreastFeedingStatic"
    
    init (){
        // As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate   = UIApplication.shared.delegate as? AppDelegate else { return }
        managedObjectContext    = appDelegate.persistentContainer.viewContext
        breastFeedingStatics    = NSEntityDescription.entity(
                forEntityName: entityName,
                in: managedObjectContext!)
    }
    
    func insert (beginDateTime: Date,
                 endDateTime:Date,
                 chestRight:Bool,
                 duration: Int) {
        let breastFeedingStatic = NSManagedObject(entity: breastFeedingStatics,
                                                  insertInto:  managedObjectContext)
      
        breastFeedingStatic.setValue(beginDateTime, forKey: "beginDateTime")
        breastFeedingStatic.setValue(endDateTime, forKey: "endDateTime")
        breastFeedingStatic.setValue(chestRight, forKey: "chestRight")
        breastFeedingStatic.setValue(duration, forKey: "duration")
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func findAll () -> [BreastFeedingStatic]? {
        // Optional result
        var result:[BreastFeedingStatic]? = nil
        
        // Add Sort Descriptor
        let sortDescriptor = NSSortDescriptor(key: "endDateTime",
                                              ascending: false)
        // Fetch Request
        let fetchRequest = NSFetchRequest<BreastFeedingStatic>(
            entityName: self.entityName)
        fetchRequest.sortDescriptors    = [sortDescriptor]

        do {
            result = try managedObjectContext.fetch(fetchRequest)
        } catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
        return result
    }
    
    func findLatestBreastFeeding () -> BreastFeedingStatic? {
        // Optional result
        var result:BreastFeedingStatic? = nil

        // Add Sort Descriptor
        let sortDescriptor = NSSortDescriptor(key: "endDateTime",
                                              ascending: false)
        // Fetch Request
        let fetchRequest = NSFetchRequest<BreastFeedingStatic>(entityName: self.entityName)
        fetchRequest.sortDescriptors    = [sortDescriptor]
        fetchRequest.fetchLimit         = 1 //  We want to fetch just a one record
    
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            result = results.first
    
        } catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
        return result
    }
    
    func findLatestBreastFeeding (forChestRight: Bool) -> BreastFeedingStatic? {
        // Optional result
        var result:BreastFeedingStatic? = nil
        
        // Add Sort Descriptor
        let sortDescriptor = NSSortDescriptor(key: "endDateTime",
                                              ascending: false)
        // Filter by breast
        let predicate = NSPredicate(format:"chestRight == %@",
                                    NSNumber(value: forChestRight))
        // Fetch Request
        let fetchRequest = NSFetchRequest<BreastFeedingStatic>(
            entityName: self.entityName)
        fetchRequest.sortDescriptors    = [sortDescriptor]
        fetchRequest.predicate          = predicate
        fetchRequest.fetchLimit         = 1 //  We want to fetch just a one record
        
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            result = results.first
        } catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
        return result
    }
    
    func findTotalBreastFeedings (forDate date: Date) -> Int {
        var total:Int = 0
        //Obtenemos la fecha de hoy dividida en componentes
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents(
            [.day, .month, .year],
            from: date)
        
        // Add Sort Descriptor
        let sortDescriptor = NSSortDescriptor(key: "endDateTime",
                                              ascending: false)
        
        // Fetch Request
        let fetchRequest = NSFetchRequest<BreastFeedingStatic>(
            entityName: self.entityName)
        
        fetchRequest.sortDescriptors    = [sortDescriptor]
        do {
            let records = try managedObjectContext.fetch(fetchRequest)
            
            for breastFeedingStatic in records {
                var beginDateComponents = calendar.dateComponents(
                    [.day, .month, .year],
                    from: breastFeedingStatic.beginDateTime!)
                
                if  dateComponents.year == beginDateComponents.year &&
                    dateComponents.month == beginDateComponents.month &&
                    dateComponents.day == beginDateComponents.day {
                    total+=1
                }
            }
            
        } catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
        return total
    }
    
    func delete(beginDateTime: Date) {
        // Filter by date
        let predicate = NSPredicate(format:"beginDateTime == %@",
                                    beginDateTime as NSDate)
        // Fetch Request
        let fetchRequest = NSFetchRequest<BreastFeedingStatic>(
            entityName: self.entityName)
            fetchRequest.predicate          = predicate
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            for item in results {
                managedObjectContext.delete(item)
            }
            
        } catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
        
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func deleteAll() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult> (
            entityName: self.entityName)
        do {
            try managedObjectContext.execute(
                NSBatchDeleteRequest(fetchRequest:fetchRequest))
        }catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func printItems (_ items: [BreastFeedingStatic] ) {
        for breastFeedingStatic in items {
            print("--------------------")
            self.printItem(breastFeedingStatic)
        }
    }

    func printItem (_ item: BreastFeedingStatic) {
        print("beginDateTime ...: \(SimpleDateFormatter.dateToString(item.beginDateTime!))")
        print("endDateTime .....: \(SimpleDateFormatter.dateToString(item.endDateTime!))")
        print("duration (secs)..: \(item.duration)")
        print("chestRight ?.....: \(item.chestRight)")
    }
}
