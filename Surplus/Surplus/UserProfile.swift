//
//  UserProfile.swift
//  Surplus
//
//  Created by Daniel Lee on 4/23/16.
//  Copyright © 2016 Daniel Lee. All rights reserved.
//

import Foundation
import CoreData

/**
 * Static class that handles storing and pulling data into/from core data (cache).
 */
class UserProfile {
    // Handle used to grab core data model
    static let coreDataManagedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    /**
     * Attempts to save current state of core data model.
     */
    class func saveContext() {
        do {
            try self.coreDataManagedContext!.save()
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    /**
     * Caches the given campus to core data and attempts to save core data state afterwards.
     */
    class func addPaymentPref(pref: String) {
        // Finds the data model for PaymentPref
        let entity = NSEntityDescription.entityForName("PaymentPref", inManagedObjectContext: coreDataManagedContext!)
        // Creates a pref data object to cache into core data
        let paymentPrefObj = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: coreDataManagedContext!)
        
        paymentPrefObj.setValue(pref, forKey: "type")
        
        saveContext()
    }
    
    /**
     * Caches the given ministry to core data and attempts to save core data state afterwards.
     */
    class func setType(hasPlus: Bool) {
        removeAllEntities("Type")
        
        let entity = NSEntityDescription.entityForName("Type", inManagedObjectContext: coreDataManagedContext!)
        let typeObj = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: coreDataManagedContext!)
        
        typeObj.setValue(hasPlus, forKey: "hasPlus")
        
        saveContext()
    }
    
    /**
     * Removes all entities for a given name such as Campus, Ministry, CommunityGroup, MinistryTeam.
     */
    class func removeAllEntities(entityName: String) {
        let fetchRequest = NSFetchRequest(entityName: entityName)
        
        do {
            let fetchedResult = try coreDataManagedContext!.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            if let entities = fetchedResult {
                for entity in entities {
                    coreDataManagedContext?.deleteObject(entity)
                }
            }
        }
        catch let error as NSError {
            // TODO: handle the error
            print(error)
        }
        
        saveContext()
    }
    
    /**
     * Fetches all payment preference entities and stores them into an array that gets returned to
     * the caller.
     */
    class func getPaymentPrefs() -> [String] {
        let fetchRequest = NSFetchRequest(entityName: "PaymentPref")
        var results = [String]()
        
        do {
            let fetchedResult = try coreDataManagedContext!.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            if let paymentPrefs = fetchedResult {
                for pref in paymentPrefs {
                    results.append(pref.valueForKey("type") as! String)
                }
            }
            else {
                print("Unable to fetch preferences")
            }
        }
        catch {
            print("Unable to fetch")
        }
        
        return results;
    }
    
    /**
     * Fetches all ministry entities and stores them into a readable MinistryData array that gets returned to
     * the caller.
     */
    class func getType() -> Bool {
        let fetchRequest = NSFetchRequest(entityName: "Type")
        var result = false
        
        do {
            let fetchedResult = try coreDataManagedContext!.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            if let types = fetchedResult {
                for type in types {
                    result = type.valueForKey("hasPlus") as! Bool
                }
            }
            else {
                print("Unable to fetch type")
            }
        }
        catch {
            print("Unable to fetch")
        }
        
        return result;
    }
}