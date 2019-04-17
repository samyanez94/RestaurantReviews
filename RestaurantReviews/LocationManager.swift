//
//  LocationManager.swift
//  RestaurantReviews
//
//  Created by Samuel Yanez on 4/16/19.
//  Copyright © 2019 Treehouse. All rights reserved.
//

import Foundation
import CoreLocation

enum LocationError: Error {
    case unknownError
    case disallowedByUser
    case unableToFindLocation
}

protocol LocationPermissionsDelegate: class {
    func authorizationSucceded()
    func authorizationFailed(_ status: CLAuthorizationStatus)
}

class LocationManager: NSObject {
    
    private let manager = CLLocationManager()
    
    weak var permissionsDelegate: LocationPermissionsDelegate?
    
    init(permissionsDelegate: LocationPermissionsDelegate) {
        super.init()
        manager.delegate = self
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
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            permissionsDelegate?.authorizationSucceded()
        } else {
            permissionsDelegate?.authorizationFailed(status)
        }
    }
}
