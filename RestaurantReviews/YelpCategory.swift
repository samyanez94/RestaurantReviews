//
//  YelpCategory.swift
//  RestaurantReviews
//
//  Created by Samuel Yanez on 5/3/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import Foundation

struct YelpCategory {
    let alias: String
    let title: String
}

extension YelpCategory: JSONDecodable {
    init?(json: [String : Any]) {
        guard let aliasValue = json["alias"] as? String, let titleValue = json["title"] as? String else { return nil }
        self.alias = aliasValue
        self.title = titleValue
    }
}
