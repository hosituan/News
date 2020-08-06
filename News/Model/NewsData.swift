//
//  News.swift
//  News
//
//  Created by Hồ Sĩ Tuấn on 8/1/20.
//  Copyright © 2020 Hồ Sĩ Tuấn. All rights reserved.
//

import UIKit

struct NewsData: Codable {
    var status: String
    var totalResults: Int
    var articles: [articles]
}

struct articles: Codable {

    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
    struct source: Codable {
        var id: String?
        var name: String?
    }
    let source: source?
    
    init(title: String, description: String, url: String, urlToImage: String) {
        self.title = title
        self.description = description
        self.url = url
        self.urlToImage = urlToImage
        self.source = nil
        self.content = nil
        self.publishedAt = nil
    }
}










