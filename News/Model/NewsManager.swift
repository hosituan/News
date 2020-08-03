//
//  NewsManager.swift
//  News
//
//  Created by Hồ Sĩ Tuấn on 8/1/20.
//  Copyright © 2020 Hồ Sĩ Tuấn. All rights reserved.
//

import UIKit
import SDWebImage
import ProgressHUD

class NewsManager {
    var newsData: NewsData?
    var getApi = GetAPI()
    var url = "https://newsapi.org/v2/top-headlines?apiKey=588436846ac040598a8cdd6505fc12e0&language=en"
    
    func fetchURL(url: String, completionHandler: @escaping () -> ()) {
        let urlString = self.url
        getApi.getFromAPI(for: NewsData.self, urlString: urlString) {
            result in
            self.newsData = result
            completionHandler()
        }
    }
    
    func getTotalResult() -> Int {
        return newsData!.articles.count
    }
    func getURLImage(_ index: Int) -> URL? {
        
        if newsData!.articles[index].urlToImage != nil {
            return URL(string: (newsData!.articles[index].urlToImage!))
        }
        return nil
    }
    func getTitle(_ index: Int) -> String {
        return newsData?.articles[index].title ?? "No Title"
    }
    
    func getTime(_ index: Int) -> String {
        if let time = newsData?.articles[index].publishedAt {
            let timeArr = time.components(separatedBy: "T")
            return timeArr[0]
        }
        return "Unknow time"
    }
    
    func getDescription(_ index: Int) -> String {
        return newsData?.articles[index].description ?? "No description"
    }
    func getLink(_ index: Int) -> String {
        return newsData?.articles[index].url ?? "This post doesn't have link"
    }
    func getSource(_ index: Int) -> String {
        return newsData?.articles[index].source.name ?? "Unknown"
    }
    func getSourceId(_ index: Int) -> String {
        return newsData?.articles[index].source.id ?? "Unknown"
    }
    
    func getContent(_ index: Int) -> String {
        return newsData?.articles[index].content ?? "This news doesn't have content."
    }
    
    func getSourceImageURL(_ index: Int) -> URL? {
        if let url = newsData?.articles[index].url {
            let urlArr = url.components(separatedBy: "/")
            if let URL = URL(string: "https://\(urlArr[2])/favicon.ico") {
                return URL
            }
        }
        return nil
    }
    func getSourceURL(_ index: Int) -> URL? {
        if let url = newsData?.articles[index].url {
            let urlArr = url.components(separatedBy: "/")
            if let URL = URL(string: "https://\(urlArr[2])") {
                return URL
            }
        }
        return nil
    }
}

