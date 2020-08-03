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
    var url = "https://newsapi.org/v2/top-headlines?apiKey=588436846ac040598a8cdd6505fc12e0&language=en"
    
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
        return newsData!.articles[index].title ?? "No Title"
    }
    
    func getTime(_ index: Int) -> String {
        if let time = newsData!.articles[index].publishedAt {
            let timeArr = time.components(separatedBy: "T")
            return timeArr[0]
        }
        return "Unknow time"
    }
    
    func getDescription(_ index: Int) -> String {
        return newsData!.articles[index].description ?? "No description"
    }
    
    func getSource(_ index: Int) -> String {
        return newsData!.articles[index].source.name ?? "Unknown"
    }
    func getContent(_ index: Int) -> String {
        return newsData!.articles[index].content ?? "This news doesn't have content."
    }
    
    
    func fetchUrl(url: String, completionHandler: @escaping () -> () ) {
        let urlString = "\(self.url)"
        getNews(urlString: urlString) {
            result in
            self.newsData = result
            completionHandler()
        }
    }
    
    func getNews(urlString: String, completionHandler: @escaping (NewsData) -> ()) {
        ProgressHUD.show()
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            session.dataTask(with: url, completionHandler: {
                (data, response, error) in
                if (error != nil) {
                    print(error!)
                    ProgressHUD.dismiss()
                    return
                }
                if let dataRespone = data {
                    if let result = self.parseJSON(data: dataRespone) {
                        ProgressHUD.dismiss()
                        completionHandler(result)
                    }
                    else {
                        ProgressHUD.dismiss()
                        print("nil result")
                    }
                }
            }).resume()
        }
    }
    
    func parseJSON(data: Data) -> NewsData?  {
        let decode = JSONDecoder()
        do {
            let result = try decode.decode(NewsData.self, from: data)
            return result
        } catch {
            print(error)
            return nil
        }
    }
}

