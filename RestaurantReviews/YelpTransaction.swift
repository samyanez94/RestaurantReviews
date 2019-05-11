//
//  YelpTransaction.swift
//  RestaurantReviews
//
//  Created by Samuel Yanez on 5/3/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import Foundation

enum YelpTransaction {
    case pickup, delivery, restaurantReservation
}

extension YelpTransaction {
    init?(rawValue: String) {
        switch rawValue {
        case "pickup": self = .pickup
        case "delivery": self = .delivery
        case "restaurant_reservation": self = .restaurantReservation
        default: return nil
        }
    }
}
