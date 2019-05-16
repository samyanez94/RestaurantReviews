//
//  YelpClient.swift
//  RestaurantReviews
//
//  Created by Samuel Yanez on 5/11/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import Foundation

class YelpClient: APIClient {
    var session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    func search(withTearm tearm: String, at coordinate: Coordinate, categories: [YelpCategory] = [], radius: Int? = nil, limit: Int = 50, sortBy sortType: Yelp.YelpSortType = .rating, completion: @escaping (Result<[YelpBusiness], APIError>) -> Void) {
        let endpoint = Yelp.search(term: tearm, coordinate: coordinate, radius: radius, categories: categories, limit: limit, sortBy: sortType)
        let request = endpoint.authorizedRequest(withKey: YelpKeys.token)
        fetch(with: request, parse: { (json) -> [YelpBusiness] in
            guard let businesses = json["businesses"] as? [[String: Any]] else { return [] }
            return businesses.compactMap { YelpBusiness(json: $0) }
        }, completion: completion)
    }
    
    func business(withID id: String, completion: @escaping (Result<YelpBusiness, APIError>) -> Void) {
        let endpoint = Yelp.business(id: id)
        let request = endpoint.authorizedRequest(withKey: YelpKeys.token)
        fetch(with: request, parse: { json -> YelpBusiness? in
            return YelpBusiness(json: json)
        }, completion: completion)
    }
    
    func updateBusiness(_ business: YelpBusiness, completion: @escaping (Result<YelpBusiness, APIError>) -> Void) {
        let endpoint = Yelp.business(id: business.id)
        let request = endpoint.authorizedRequest(withKey: YelpKeys.token)
        fetch(with: request, parse: { json -> YelpBusiness? in
            business.updateWithHoursAndPhotos(json: json)
            return business
        }, completion: completion)
    }
}
