//
//  SavedNewsCoreDataManager.swift
//  News
//
//  Created by Hồ Sĩ Tuấn on 8/6/20.
//  Copyright © 2020 Hồ Sĩ Tuấn. All rights reserved.
//

import UIKit
import CoreData
import SwiftLinkPreview
import RxCocoa
import RxSwift
import Sync

class SavedNewsCoreDataManager: NSObject {
    var savedNewsData: [NSManagedObject] = []
    
    var searchInput = BehaviorRelay<String?>(value: "")
    var saveNewsResult = BehaviorRelay<[articles]>(value: [])
    var searchResult = BehaviorRelay<[articles]>(value: [])
    let dispose = DisposeBag()
    
    override init() {
        super.init()
        bindingData()
    }
    func loadData()
    {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedNews")
        do {
            savedNewsData = try managedContext.fetch(fetchRequest)
            var savedNewsArray: [articles] = []
            for item in savedNewsData {
                let title = (item.value(forKey: "title") as! String)
                let description = (item.value(forKey: "descriptionNews") as! String)
                let urlToImage = (item.value(forKey: "imageLink") as! String)
                let url = (item.value(forKey: "link") as! String)
                let news: articles = articles(title: title, description: description, url: url, urlToImage: urlToImage)

                savedNewsArray.append(news)
                
            }
            saveNewsResult.accept(savedNewsArray)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    func bindingData() {
            self.searchInput.asObservable().subscribe(onNext: { (text) in
                 if text!.isEmpty || text!.contains(" "){
                    self.searchResult.accept(self.saveNewsResult.value)
                 }
                else {
                    var objectArray: [articles] = []
                    for index in stride(from: self.saveNewsResult.value.count - 1, to: -1, by: -1)
                    {
                        let title = self.saveNewsResult.value[index].title ?? "No Title"
                        if title.lowercased().contains("\(text!.lowercased())") {
                            objectArray.insert(self.saveNewsResult.value[index], at: 0)
                        }
                    }
                    self.searchResult.accept(objectArray)
                }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: dispose)
    }
    
    func getTotalResult() -> Int {
        return savedNewsData.count
    }
    
    func createData(title: String, description: String, imageLink: String, link: String ) {
      guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else {
            return
      }
      let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "SavedNews", in: managedContext)!
        let data = NSManagedObject(entity: entity, insertInto: managedContext)

        data.setValue(title, forKeyPath: "title")
        data.setValue(description, forKey: "descriptionNews")
        data.setValue(imageLink, forKey: "imageLink")
        data.setValue(link, forKey: "link")
      do {
        try managedContext.save()
      }
      catch let error as NSError {
        print("Could not save. \(error), \(error.userInfo)")
      }
    }
    func deleteData(object: NSManagedObject)
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedNews")
        do {
            let tasks = try managedObjectContext.fetch(fetchRequest)
            for data in tasks {
                if (data == object) {
                    managedObjectContext.delete(data)
                }
            }
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
    
    func deleteAllData()
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedNews")
        do {
            let tasks = try managedObjectContext.fetch(fetchRequest)
            for data in tasks {
                managedObjectContext.delete(data)
            }
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

    
    
    func getLink(_ index: Int) -> String {
        return savedNewsData[index].value(forKey: "link") as? String ?? "https://google.com"
    }
    func getTitle(_ index: Int) -> String {
        return savedNewsData[index].value(forKey: "title") as? String ?? "Unknown"
    }
    func getDescription(_ index: Int) -> String {
        return savedNewsData[index].value(forKey: "descriptionNews") as? String ?? "No Description"
    }
    func getImageLink(_ index: Int) -> String {
        return savedNewsData[index].value(forKey: "imageLink") as? String ?? "https://google.com/favicon.ico"
    }
    
    


}

