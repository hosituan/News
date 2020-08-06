//
//  CoreDataManager.swift
//  News
//
//  Created by Hồ Sĩ Tuấn on 8/5/20.
//  Copyright © 2020 Hồ Sĩ Tuấn. All rights reserved.
//

import UIKit
import CoreData

class SettingCoreDataManager {
    var settingData: [NSManagedObject] = []
    
    func loadData()
    {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserData")
        fetchRequest.fetchLimit = 1
        do {
            settingData = try managedContext.fetch(fetchRequest)
            if settingData.count == 0 {
                createData()
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    func updateFavoriteCategory(_ category: [String]) {
        let categoryString = category.joined(separator: ",")
        updateData(content: categoryString, forkey: "favoriteCategory")
    }
    func updateLanguage(_ language: String) {
        updateData(content: language, forkey: "language")
    }
    func updateShowFavorite(_ isShow: Bool) {
        updateData(content: isShow, forkey: "showFavorite")
    }
    func updateData(content: Any, forkey: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserData")
        do {
            let tasks = try managedObjectContext.fetch(fetchRequest)
            tasks[0].setValue(content, forKey: forkey)
            do {
                try managedObjectContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func createData() {
      guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else {
            return
      }
      // 1
      let managedContext = appDelegate.persistentContainer.viewContext
      
      // 2
        let entity = NSEntityDescription.entity(forEntityName: "UserData", in: managedContext)!
      
        let data = NSManagedObject(entity: entity, insertInto: managedContext)
      
      // 3
        data.setValue("en", forKeyPath: "language")
        data.setValue("", forKey: "favoriteCategory")
        data.setValue(false, forKey: "showFavorite")
      // 4
      do {
        try managedContext.save()
      }
      catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
      }
    }
    
    func getLanguage() -> String {
        if settingData.count > 0 {
            return settingData[0].value(forKeyPath: "language") as? String ?? "en"
        }
        else  { return "en" }
    }
    func getCategory() -> [String] {
        if settingData.count > 0 {
            let category = settingData[0].value(forKey: "favoriteCategory") as? String
            let categoryArray = category?.components(separatedBy: ",")
            return categoryArray ?? []
        }
        else {
            return []
        }
    }
    func getShowFavorite() -> Bool {
        if settingData.count > 0 {
            return settingData[0].value(forKey: "showFavorite") as? Bool ?? true
        }
        else { return false }
    }
}
