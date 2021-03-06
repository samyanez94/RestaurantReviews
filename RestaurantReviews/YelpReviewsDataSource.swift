//
//  YelpReviewsDataSource.swift
//  RestaurantReviews
//
//  Created by Samuel Yanez on 5/3/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import Foundation
import UIKit

protocol YelpReviewsDataSourceDelegate {
    func reloadData()
}

class YelpReviewsDataSource: NSObject, UITableViewDataSource {
    private var data: [YelpReview]
    
    let pendingOperations = PendingOperations()
    
    let delegate: YelpReviewsDataSourceDelegate
    
    init(data: [YelpReview], delegate: YelpReviewsDataSourceDelegate) {
        self.data = data
        self.delegate = delegate
        super.init()
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: YelpReviewCell.reuseIdentifier, for: indexPath) as! YelpReviewCell
        
        let review = object(at: indexPath)
        let viewModel = YelpReviewCellViewModel(review: review)
        
        cell.configure(with: viewModel)
        
        if review.user.imageState == .placeholder {
            downloadImage(for: review.user, atIndexPath: indexPath)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Reviews"
    }
    
    // MARK: Helpers
    
    func update(_ object: YelpReview, at indexPath: IndexPath) {
        data[indexPath.row] = object
    }
    
    func updateData(_ data: [YelpReview]) {
        self.data = data
    }
    
    func object(at indexPath: IndexPath) -> YelpReview {
        return data[indexPath.row]
    }
    
    func downloadImage(for user: YelpUser, atIndexPath indexPath: IndexPath) {
        if let _ = pendingOperations.downloadsInProgress[indexPath] {
            return
        }
        
        let downloader = YelpUserImageOperation(user: user)
        
        downloader.completionBlock = {
            if downloader.isCancelled {
                return
            }
            DispatchQueue.main.async {
                self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                self.delegate.reloadData()
            }
        }
        pendingOperations.downloadsInProgress[indexPath] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
    }
}
