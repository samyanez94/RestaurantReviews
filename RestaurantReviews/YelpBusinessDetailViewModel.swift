//
//  YelpBusinessDetailViewModel.swift
//  RestaurantReviews
//
//  Created by Samuel Yanez on 5/3/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import Foundation

struct YelpBusinessDetailViewModel {
    let restaurantName: String
    let price: String
    let rating: Double
    let ratingsCount: String
    let categories: String
    let hours: String
    let currentStatus: String
}

extension YelpBusinessDetailViewModel {
    init?(business: YelpBusiness) {
        self.restaurantName = business.name
        self.price = business.price
        self.rating = business.rating
        self.ratingsCount = "(\(business.reviewCount.description))"
        
        self.categories = business.categories.map({ $0.title }).joined(separator: ", ")
        
        guard let hours = business.hours else { return nil }
        
        guard let today = hours.schedule.filter({ $0.day.rawValue == Date.currentDay }).first else { return nil }
        
        let startString = DateFormatter.stringFromDateString(today.start, withInputDateFormat: "HHmm")
        let endString = DateFormatter.stringFromDateString(today.end, withInputDateFormat: "HHmm")
        
        self.hours = "Hours Today: \(startString) - \(endString)"
        self.currentStatus = business.isOpenNow ? "Open" : "Closed"
    }
}

extension DateFormatter {
    static func stringFromDateString(_ inputString: String, withInputDateFormat format: String) -> String {
        let formatter = DateFormatter()
        let locale = Locale.current
        formatter.locale = locale
        
        formatter.dateFormat = format
        
        let date = formatter.date(from: inputString)!
        
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        
        return formatter.string(from: date)
    }
}

extension Date {
    static var currentDay: Int {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: date)
        
        let day = components.day! % 7
        
        return day
    }
}
