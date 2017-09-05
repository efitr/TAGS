//
//  CoraData.swift
//  AlertController
//
//  Created by Egon Fiedler on 8/1/17.
//  Copyright © 2017 App Solutions. All rights reserved.

import CoreData
import UIKit

class CoreDataHelper {
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let persistentContainer = appDelegate.persistentContainer
    static let managedContext = persistentContainer.viewContext
    
    static func newTagedPhoto() -> TagedPhoto {
        let tagedPhoto = NSEntityDescription.insertNewObject(forEntityName: "TagedPhoto", into: managedContext) as! TagedPhoto
        return tagedPhoto
    }
    
    static func saveTagedPhoto() {
        do{
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error)")
        }
    }

    static func delete(tagedPhoto: TagedPhoto) {
        managedContext.delete(tagedPhoto)
        saveTagedPhoto()
    }
    
    static func retrievetagedPhoto() -> [TagedPhoto] {
        let fetchRequest = NSFetchRequest<TagedPhoto>(entityName: "TagedPhoto")
        do {
            let results = try managedContext.fetch(fetchRequest)
            return results
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        return []
    }

}
