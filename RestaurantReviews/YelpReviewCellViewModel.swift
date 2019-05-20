//
//  YelpReviewCellViewModel.swift
//  RestaurantReviews
//
//  Created by Samuel Yanez on 5/3/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import Foundation
import UIKit

struct YelpReviewCellViewModel {
    let review: String
    let userImage: UIImage?
}

extension YelpReviewCellViewModel {
    init(review: YelpReview) {
        self.review = review.text
        self.userImage = review.user.image ?? nil
    }
}
