//
//  YelpUserImageOperation.swift
//  RestaurantReviews
//
//  Created by Samuel Yanez on 5/19/19.
//  Copyright © 2019 Treehouse. All rights reserved.
//

import Foundation
import UIKit

class PendingOperations {
    var downloadsInProgress = [IndexPath: Operation]()
    
    let downloadQueue = OperationQueue()
}

class YelpUserImageOperation: Operation {
    let user: YelpUser
    
    init(user: YelpUser) {
        self.user = user
        super.init()
    }
    
    override func main() {
        if self.isCancelled {
            return
        }
        
        guard let url = URL(string: user.imageUrl) else {
            return
        }
        
        let imageData = try! Data(contentsOf: url)
        
        if self.isCancelled {
            return
        }
        
        if imageData.count > 0 {
            user.image = UIImage(data: imageData)
            user.imageState = .downloaded
        } else {
            user.imageState = .failed
        }
    }
}
