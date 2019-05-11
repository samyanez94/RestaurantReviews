//
//  ReviewCellViewModel.swift
//  RestaurantReviews
//
//  Created by Samuel Yanez on 5/3/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import Foundation
import UIKit

struct ReviewCellViewModel {
    let review: String
    let userImage: UIImage
}

extension ReviewCellViewModel {
    init(review: YelpReview) {
        self.review = review.text
        self.userImage = review.user.image ?? #imageLiteral(resourceName: "Placeholder")
    }
}
