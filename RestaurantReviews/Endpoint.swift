//
//  Endpoint.swift
//  RestaurantReviews
//
//  Created by Samuel Yanez on 5/3/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import Foundation

protocol Endpoint {
    var base: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
}

extension Endpoint {

    var urlComponents: URLComponents {
        var components = URLComponents(string: base)!
        components.path = path
        components.queryItems = queryItems
        
        return components
    }
    
    var request: URLRequest {
        let url = urlComponents.url!
        return URLRequest(url: url)
    }
    
    func authorizedRequest(withKey key: String) -> URLRequest {
        var authorizedRequest  = request
        authorizedRequest.addValue("Bearer \(key)", forHTTPHeaderField: "Authorization")
        return authorizedRequest
    }
}

enum Yelp {
    enum YelpSortType: CustomStringConvertible {
        case bestMatch, rating, reviewCount, distance
        
        var description: String {
            switch self {
            case .bestMatch: return "best_match"
            case .rating: return "rating"
            case .reviewCount: return "review_count"
            case .distance: return "distance"
            }
        }
    }
    
    case search(term: String, coordinate: Coordinate, radius: Int?, categories: [YelpCategory], limit: Int?, sortBy: YelpSortType?)
    case business(id: String)
    case reviews(businessId: String)
}

extension Yelp: Endpoint {
    var base: String {
        return "https://api.yelp.com"
    }
    
    var path: String {
        switch self {
        case .search: return "/v3/businesses/search"
        case .business(let id): return "/v3/businesses/\(id)"
        case .reviews(let id): return "/v3/businesses/\(id)/reviews"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .search(let term, let coordinate, let radius, let categories, let limit, let sortBy):
            return [
                URLQueryItem(name: "term", value: term),
                URLQueryItem(name: "latitude", value: coordinate.latitude.description),
                URLQueryItem(name: "longitude", value: coordinate.longitude.description),
                URLQueryItem(name: "radius", value: radius?.description),
                URLQueryItem(name: "categories", value: categories.map({$0.alias}).joined(separator: ",")),
                URLQueryItem(name: "limit", value: limit?.description),
                URLQueryItem(name: "sort_by", value: sortBy?.description)
            ]
        case .business: return []
        case .reviews: return []
        }
    }
}
