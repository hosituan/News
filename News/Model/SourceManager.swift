//
//  SourceManager.swift
//  News
//
//  Created by Hồ Sĩ Tuấn on 8/3/20.
//  Copyright © 2020 Hồ Sĩ Tuấn. All rights reserved.
//

import Foundation

class SourceManager {
    var sourceData: SourceData?
    let getApi = GetAPI()
    var url = "https://newsapi.org/v2/sources?apiKey=588436846ac040598a8cdd6505fc12e0"
    func fetchURL(url: String, completionHandler: @escaping () -> ()) {
        let urlString = self.url
        getApi.getFromAPI(for: SourceData.self, urlString: urlString) {
            result in
            self.sourceData = result
            completionHandler()
        }
    }
    
    func getImageURL(_ id: String) -> URL? {
        if sourceData != nil {
            for i in sourceData!.sources {
                if i.id == id {
                    if i.url != nil {
                        print("\(i.url!)/favicon.ico")
                        return URL(string: "\(i.url!)/favicon.ico")
                    }
                }
            }
        }
        return nil
    }
    
    func getUrl(_ id: String) -> URL? {
        if sourceData != nil {
            for i in sourceData!.sources {
                if i.id == id {
                    print("go here3")
                    if i.url != nil {
                        return URL(string: i.url!)
                    }
                }
            }
        }
        return nil
    }
}
