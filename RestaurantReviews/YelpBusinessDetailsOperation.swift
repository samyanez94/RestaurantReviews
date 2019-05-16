//
//  YelpBusinessDetailsOperation.swift
//  RestaurantReviews
//
//  Created by Samuel Yanez on 5/11/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import Foundation

class YelpBusinessDetailsOperation: Operation {
    let business: YelpBusiness
    let client: YelpClient
    
    init(business: YelpBusiness, client: YelpClient) {
        self.business = business
        self.client = client
        super.init()
    }
}
