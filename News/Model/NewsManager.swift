//
//  NewsManager.swift
//  News
//
//  Created by Hồ Sĩ Tuấn on 8/1/20.
//  Copyright © 2020 Hồ Sĩ Tuấn. All rights reserved.
//

import UIKit
import SDWebImage
import CoreData
import SwiftLinkPreview

var language = "en"
var favoriteCategory:[String] = [] //favorite category
var coreDataManager = SettingCoreDataManager()
var category:String = ""


class NewsManager {
    var articles: [articles] = []
    var getApi = GetAPI()
    
    var url = "https://newsapi.org/v2/top-headlines?apiKey=588436846ac040598a8cdd6505fc12e0&pageSize=100"
    
    
    func fetchURL(completionHandler: @escaping () -> ()) {
        articles.removeAll()
        coreDataManager.loadData()
        language = coreDataManager.getLanguage()
        favoriteCategory = coreDataManager.getCategory()
        print("favorite category:\(favoriteCategory)")
        print("language:\(language)")
        print("category:\(category)")
        let isShowFavotie = coreDataManager.getShowFavorite()
        print("show favorite:\(isShowFavotie)")
        if category == "all" || ( !isShowFavotie && category != "myFeed") || favoriteCategory.count == 0  || ( favoriteCategory.count  == 1 && favoriteCategory[0] == "" )
        {
            let urlString = "\(self.url)&language=\(language)"
            print(urlString)
            getApi.getFromAPI(for: NewsData.self, urlString: urlString) {
                result in
                self.articles = result.articles
                completionHandler()
            }
        }
        else {
            let count = favoriteCategory.count
            let myGroup = DispatchGroup()
            for i in 0..<count {
                if (favoriteCategory[i] != "") {
                    myGroup.enter()
                    let urlString = "\(self.url)&language=\(language)&category=\(favoriteCategory[i])"
                    print(urlString)
                    getApi.getFromAPI(for: NewsData.self, urlString: urlString) {
                        result in
                        self.articles.append(contentsOf: result.articles)
                        myGroup.leave()
                    }
                }
            }
            myGroup.notify(queue: .main) {
                self.articles.shuffle() //shuffle category
                completionHandler()
            }
            
            
        }
        
    }
    
    func getShowingCategory() -> String {
        switch category {
        case "":
            if coreDataManager.getShowFavorite() {
                return "Favorite Categories"
            }
            return "All News"
        case "all":
            return "All News"
        case "myFeed":
            return "Favorite Categories"
        default:
            return "Saved News"
        }
        
    }
    
    func getTotalResult() -> Int {
        print(articles.count)
        return articles.count
    }
    func getURLImage(_ index: Int) -> URL {
        let noImageUrl = "https://lh3.googleusercontent.com/proxy/Pae83kprRF_GH8bb5YREkoE8iU6sx1ZeaRvemPjw1qu67mWqulZwneMhVuECtfy6mONmZUg0UuNvDc-JYv7t1ftwJCoHNGeW1wI3mR5k1FBu-5KL0-1-XjLW"
        if articles[index].urlToImage != nil {
            if let url = URL(string: (articles[index].urlToImage!)) {
                return url
            }
            return URL(string: noImageUrl)!
        }
        //no image URL
        return URL(string: noImageUrl)!
    }
    func getTitle(_ index: Int) -> String {
        return articles[index].title ?? "No Title"
    }
    
    func getTime(_ index: Int) -> String {
        if let time = articles[index].publishedAt {
            let timeArr = time.components(separatedBy: "T")
            return timeArr[0]
        }
        return "Unknow time"
    }
    
    func getDescription(_ index: Int) -> String {
        return articles[index].description ?? "No description"
    }
    func getLink(_ index: Int) -> String {
        return articles[index].url ?? "This post doesn't have link"
    }
    func getSource(_ index: Int) -> String {
        return articles[index].source?.name ?? "Unknown"
    }
    func getSourceId(_ index: Int) -> String {
        return articles[index].source?.id ?? "Unknown"
    }
    
    func getContent(_ index: Int) -> String {
        return articles[index].content ?? "This news doesn't have content."
    }
    
    func getSourceURL(_ index: Int) -> URL {
        if let url = articles[index].url {
            let urlArr = url.components(separatedBy: "/")
            if let URL = URL(string: "https://\(urlArr[2])/") {
                return URL
            }
        }
        return URL(string: "https://www.google.com/")!
    }
    
    func getTempSourceImageURL(_ index: Int) -> URL {
        if let url = articles[index].url {
            let urlArr = url.components(separatedBy: "/")
            if let URL = URL(string: "https://\(urlArr[2])/favicon.ico") {
                return URL
            }
        }
        return URL(string: "https://www.google.com/favicon.ico")!
    }
    
    func getSourceImageURL(_ index: Int, completionHandler: @escaping (URL)-> ()){
        if let url = articles[index].url {
            getIconURL(url: url) {
                finalLink in
                if let link = URL(string: finalLink) {
                    completionHandler(link)
                }
            }
        }
    }
    
    func getIconURL(url: String, completionHandler: @escaping (String) -> ()) {
        var finalLink = ""
        let session: URLSession = URLSession.shared
        let workQueue: DispatchQueue = SwiftLinkPreview.defaultWorkQueue
        let responseQueue: DispatchQueue = DispatchQueue.main
        let cache: Cache = DisabledCache.instance
        let linkPre = SwiftLinkPreview(session: session, workQueue: workQueue, responseQueue: responseQueue, cache: cache)
        linkPre.preview(url,
                        onSuccess: {
                            result in
                            if let iconLink = result.icon {
                                finalLink = iconLink
                                completionHandler(finalLink)
                            }
        },
                        onError: { error in print("\(error)")})
    }
}

