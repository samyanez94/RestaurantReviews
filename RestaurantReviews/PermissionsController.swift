//
//  PermissionsController.swift
//  RestaurantReviews
//
//  Created by Samuel Yanez on 5/3/19.
//  Copyright © 2019 Samuel Yanez. All rights reserved.
//

import UIKit
import CoreLocation

class PermissionsController: UIViewController {
    
    lazy var locationManager: LocationManager = {
        return LocationManager(managerDelegate: nil, permissionsDelegate: self)
    }()
    
    var isAuthorizedForLocation: Bool
    
    lazy var locationPermissionButton:  UIButton = {
        let title = self.isAuthorizedForLocation ? "Location Permissions Granted" : "Request Location Permissions"
        let button = UIButton(type: .system)
        let controlState = self.isAuthorizedForLocation ? UIControl.State.disabled : UIControl.State.normal
        button.isEnabled = !self.isAuthorizedForLocation
        button.setTitle(title, for: controlState)
        button.addTarget(self, action: #selector(PermissionsController.requestLocationPermissions), for: .touchUpInside)
        
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red: 62/255.0, green: 71/255.0, blue: 79/255.0, alpha: 1.0)
        button.setTitleColor(UIColor(red: 178/255.0, green: 187/255.0, blue: 185/255.0, alpha: 1.0), for: .disabled)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        
        return button
    }()
    
    lazy var dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Dismiss", for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(PermissionsController.dismissPermissions), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init coder not implemented")
    }
    
    init(isAuthorizedForLocation authorized: Bool) {
        self.isAuthorizedForLocation = authorized
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 95/255.0, green: 207/255.0, blue: 128/255.0, alpha: 1.0)
    }
    

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let stackView = UIStackView(arrangedSubviews: [locationPermissionButton])
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 16.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        view.addSubview(dismissButton)
        
        NSLayoutConstraint.activate([
            locationPermissionButton.heightAnchor.constraint(equalToConstant: 64.0),
            locationPermissionButton.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            locationPermissionButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32.0),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32.0),
            dismissButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
    }
    
    @objc func requestLocationPermissions() {
        do {
            try locationManager.requestLocationAuthorization()
        } catch LocationError.disallowedByUser {
            present(alertForLocationPermissionsDenied(), animated: true)
        } catch {
            print("Location Authorization Error: \(error.localizedDescription)")
        }
    }
    
    @objc func dismissPermissions() {
        dismiss(animated: true, completion: nil)
    }
}

extension PermissionsController: LocationPermissionsDelegate {
    
    func authorizationSucceded() {
        locationPermissionButton.setTitle("Location Permissions Granted", for: .disabled)
        locationPermissionButton.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    func authorizationFailed(_ status: CLAuthorizationStatus) {
        present(alertForLocationPermissionsDenied(), animated: true)
    }
    
    func alertForLocationPermissionsDenied() -> UIAlertController {
        let alert = UIAlertController(title: "Location Access Required", message: "This app requires access to your location when in use. Please, allow this access in the Settings app.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (action) in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        return alert
    }
}
