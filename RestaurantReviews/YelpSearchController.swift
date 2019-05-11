//
//  YelpSearchController.swift
//  RestaurantReviews
//
//  Created by Samuel Yanez on 5/3/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import UIKit

class YelpSearchController: UIViewController {
    
    // MARK: - Properties
    
    let searchController = UISearchController(searchResultsController: nil)
    
    let dataSource = YelpSearchResultsDataSource()
    
    lazy var locationManager: LocationManager = {
        return LocationManager(managerDelegate: self, permissionsDelegate: nil)
    }()
    
    var coordinate: Coordinate?
    
    @IBOutlet weak var tableView: UITableView!
    
    var isAuthorized: Bool {
        return LocationManager.isAuthorized
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isAuthorized {
            locationManager.requestLocation()
        } else {
            checkPermissions()
        }
        
    }
    
    // MARK: - Table View
    
    func setupTableView() {
        self.tableView.dataSource = dataSource
        self.tableView.delegate = self
    }
    
    // MARK: - Search
    
    func setupSearchBar() {
        self.navigationItem.titleView = searchController.searchBar
        
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
    }
    
    // MARK: - Permissions
    
    func checkPermissions() {
        let permissionsController = PermissionsController(isAuthorizedForLocation: LocationManager.isAuthorized)
        present(permissionsController, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate
extension YelpSearchController: UITableViewDelegate {
    
}

// MARK: - Search Results
extension YelpSearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchTerm = searchController.searchBar.text else { return }
        
        print("Search text: \(searchTerm)")
    }
}

// MARK: - Navigation
extension YelpSearchController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBusiness" {
            
        }
    }
}

// MARK: - Location Manager Delegate
extension YelpSearchController: LocationManagerDelegate {
    func obtainedCoordinates(_ coordinate: Coordinate) {
        self.coordinate = coordinate
        print(coordinate)
    }
    
    func failedWithError(_ error: LocationError) {
        print(error)
    }
}

