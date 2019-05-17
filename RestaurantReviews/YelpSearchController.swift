//
//  YelpSearchController.swift
//  RestaurantReviews
//
//  Created by Samuel Yanez on 5/3/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import UIKit
import CoreLocation

class YelpSearchController: UIViewController {
    
    // MARK: - Properties
    
    let searchController = UISearchController(searchResultsController: nil)
    
    let dataSource = YelpSearchResultsDataSource()
    
    lazy var locationManager: LocationManager = {
        return LocationManager(managerDelegate: self, permissionsDelegate: self)
    }()
    
    lazy var client = YelpClient()
    
    var coordinate: Coordinate? {
        didSet {
            if let coordinate = coordinate {
                showNearbyRestaurants(at: coordinate)
            }
        }
    }
    
    let queue = OperationQueue()
    
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
            requestLocationAuthorization()
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
    
    func requestLocationAuthorization() {
        do {
            try locationManager.requestLocationAuthorization()
        } catch LocationError.disallowedByUser {
            present(alertForLocationPermissionsDenied(), animated: true)
        } catch {
            print("Location Authorization Error: \(error.localizedDescription)")
        }
    }
    
    func alertForLocationPermissionsDenied() -> UIAlertController {
        let alert = UIAlertController(title: "Location Access Required", message: "This app requires access to your location when in use. Please, allow access in the Settings app.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (action) in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }))
        return alert
    }
    
    func showNearbyRestaurants(at coordinate: Coordinate) {
        client.search(withTearm: "", at: coordinate) { [weak self] (result) in
            switch result {
            case .success(let businesses):
                self?.dataSource.update(with: businesses)
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension YelpSearchController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let business = dataSource.object(at: indexPath)
        let detailsOperation = YelpBusinessDetailsOperation(business: business, client: client)
        let reviewsOperation = YelpBusinessReviewsOperation(business: business, client: client)
        reviewsOperation.addDependency(detailsOperation)
        reviewsOperation.completionBlock = {
            DispatchQueue.main.async {
                self.dataSource.update(business, at: indexPath)
                self.performSegue(withIdentifier: "showBusiness", sender: nil)
            }
        }
        queue.addOperation(detailsOperation)
        queue.addOperation(reviewsOperation)
    }
}

// MARK: - Search Results
extension YelpSearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchTerm = searchController.searchBar.text, let coordinate = coordinate else { return }
        
        if !searchTerm.isEmpty {
            client.search(withTearm: searchTerm, at: coordinate) { [weak self] (result) in
                switch result {
                case .success(let businesses):
                    self?.dataSource.update(with: businesses)
                    self?.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

// MARK: - Navigation
extension YelpSearchController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBusiness", let indexPath = tableView.indexPathForSelectedRow {
            let business = dataSource.object(at: indexPath)
            let detailController = segue.destination as! YelpBusinessDetailController
            detailController.business = business
            detailController.dataSource.updateData(business.reviews)
        }
    }
}

extension YelpSearchController: LocationPermissionsDelegate {
    
    func authorizationSucceded() {}
    
    func authorizationFailed(_ status: CLAuthorizationStatus) {
        present(alertForLocationPermissionsDenied(), animated: true)
    }
}

// MARK: - Location Manager Delegate
extension YelpSearchController: LocationManagerDelegate {
    func obtainedCoordinates(_ coordinate: Coordinate) {
        self.coordinate = coordinate
    }
    
    func failedWithError(_ error: LocationError) {
        print(error)
    }
}

