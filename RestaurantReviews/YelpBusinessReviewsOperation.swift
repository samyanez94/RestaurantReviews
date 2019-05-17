//
//  YelpBusinessReviewsOperation.swift
//  RestaurantReviews
//
//  Created by Samuel Yanez on 5/16/19.
//  Copyright © 2019 Treehouse. All rights reserved.
//

import Foundation

class YelpBusinessReviewsOperation: Operation {
    let business: YelpBusiness
    let client: YelpClient
    
    private var _finished = false
    
    private var _executing = false
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override private(set) var isFinished: Bool {
        get {
            return _finished
        }
        set {
            willChangeValue(forKey: "isFinished")
            _finished = newValue
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override private(set) var isExecuting: Bool {
        get {
            return _executing
        }
        set {
            willChangeValue(forKey: "isExecuting")
            _executing = newValue
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    init(business: YelpBusiness, client: YelpClient) {
        self.business = business
        self.client = client
        super.init()
    }
    
    override func start() {
        if isCancelled {
            isFinished = true
            return
        }
        isExecuting = true
        
        client.reviews(for: business) { [unowned self] (result) in
            switch result {
            case .success(let reviews):
                self.business.reviews = reviews
                self.isExecuting = false
                self.isFinished = true
            case .failure(_):
                self.isExecuting = false
                self.isFinished = true
            }
        }
    }
}
