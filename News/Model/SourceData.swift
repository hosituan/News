//
//  Source.swift
//  News
//
//  Created by Hồ Sĩ Tuấn on 8/3/20.
//  Copyright © 2020 Hồ Sĩ Tuấn. All rights reserved.
//

import Foundation


struct SourceData: Codable {
    var status: String
    var sources: [sources]
}
struct sources: Codable {
    var id: String?
    var name: String?
    var description: String?
    var url: String?
}
