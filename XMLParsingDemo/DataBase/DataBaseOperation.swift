//
//  DataBaseOperation.swift
//  XMLParsingDemo
//
//  Created by Sandeep Kakde on 01/12/19.
//  Copyright © 2019 Sandeep Kakde. All rights reserved.
//



import Foundation
import CoreData
import UIKit

struct TechnologyNews {
    var newsTitle: String
}
class DataBaseOperation {
    
    lazy var entityName: String = "News"
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "XMLParsingDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    func createData(news: TechnologyNews){
        //If news is already in database then dont create new entry
        if !checkIfAlreadyExist(title: news.newsTitle) {
            let managedContext = persistentContainer.viewContext
            let bookEntity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)!
            let user = NSManagedObject(entity: bookEntity, insertInto: managedContext)
            user.setValue(news.newsTitle, forKey: "title")
            do {
                try managedContext.save()
                
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        
    }
    
    private func checkIfAlreadyExist(title: String) -> Bool {
        
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "title = %@", title)
        do {
            let result = try managedContext.fetch(fetchRequest)
            if result.count == 0 {
                return false
            } else {
                return true
            }
            
        } catch {
            return false
        }
        
    }
    
    func retrieveNewsData() -> [NSManagedObject]? {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            return result as? [NSManagedObject]
        } catch {
            print("Failed")
        }
        return nil
    }
    
    func updateData(title: String, newTitle: String){
        let managedContext = persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "title = %@", title)
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            let objectUpdate = test.first as! NSManagedObject
            objectUpdate.setValue("title", forKey: newTitle)
            do{
                try managedContext.save()
            }
            catch {
                print(error)
            }
        }
        catch {
            print(error)
        }
        
    }
    
    func deleteNewsData(title: String){
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "title = %@", title)
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            let objectToDelete = test.first as! NSManagedObject
            managedContext.delete(objectToDelete)
            
            do{
                try managedContext.save()
            }
            catch {
                print(error)
            }
        }
        catch {
            print(error)
        }
    }
}
