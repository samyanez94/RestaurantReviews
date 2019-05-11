//
//  LocationManager.swift
//  RestaurantReviews
//
//  Created by Samuel Yanez on 5/3/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import Foundation
import CoreLocation

extension Coordinate {
    init(location: CLLocation) {
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
    }
}

enum LocationError: Error {
    case unknownError
    case disallowedByUser
    case unableToFindLocation
}

protocol LocationPermissionsDelegate: class {
    func authorizationSucceded()
    func authorizationFailed(_ status: CLAuthorizationStatus)
}

protocol LocationManagerDelegate: class {
    func obtainedCoordinates(_ coordinate: Coordinate)
    func failedWithError(_ error: LocationError)
}

class LocationManager: NSObject {
    
    private let manager = CLLocationManager()
    
    static var isAuthorized: Bool {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            return true
        default:
            return false
        }
    }
    
    weak var permissionsDelegate: LocationPermissionsDelegate?
    
    weak var managerDelegate: LocationManagerDelegate?
    
    init(managerDelegate: LocationManagerDelegate?, permissionsDelegate: LocationPermissionsDelegate?) {
        super.init()
        manager.delegate = self
        self.managerDelegate = managerDelegate
        self.permissionsDelegate = permissionsDelegate
    }
    
    func requestLocationAuthorization() throws {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        
        if authorizationStatus == .restricted || authorizationStatus == .denied {
            throw LocationError.disallowedByUser
        } else if authorizationStatus == .notDetermined {
            manager.requestWhenInUseAuthorization()
        } else {
            return
        }
    }
    
    func requestLocation() {
        manager.requestLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            permissionsDelegate?.authorizationSucceded()
        } else if status == .denied || status == .restricted {
            permissionsDelegate?.authorizationFailed(status)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            managerDelegate?.failedWithError(.unableToFindLocation)
            return
        }
        managerDelegate?.obtainedCoordinates(Coordinate(location: location))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let error = error as? CLError else {
            managerDelegate?.failedWithError(.unknownError)
            return
        }
        switch error.code {
        case .locationUnknown, .network:
            managerDelegate?.failedWithError(.unableToFindLocation)
        case .denied:
            managerDelegate?.failedWithError(.disallowedByUser)
        default:
            return
        }
    }
}
