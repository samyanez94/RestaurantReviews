//
//  YelpSearchResultsDataSource.swift
//  RestaurantReviews
//
//  Created by Samuel Yanez on 5/3/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import Foundation
import UIKit

class YelpSearchResultsDataSource: NSObject, UITableViewDataSource {
    
    private var data = [YelpBusiness]()
    
    override init() {
        super.init()
    }
    
    // MARK: Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath)

        let business = object(at: indexPath)
        cell.textLabel?.text = business.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Businesses"
        default: return nil
        }
    }
    
    // MARK: Helpers
    
    func object(at indexPath: IndexPath) -> YelpBusiness {
        return data[indexPath.row]
    }
    
    func indexPathFor(_ object: YelpBusiness) -> IndexPath? {
        if let row = data.firstIndex(of: object) {
            return IndexPath(row: row, section: 0)
        }
        return nil
    }
    
    func update(with data: [YelpBusiness]) {
        self.data = data
    }
    
    func update(_ object: YelpBusiness, at indexPath: IndexPath) {
        data[indexPath.row] = object
    }
}
