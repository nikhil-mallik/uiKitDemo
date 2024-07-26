//
//  LocationManager.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 24/07/24.
//

import Foundation
import CoreLocation

class LocationPermissionManager: NSObject, CLLocationManagerDelegate {
    
    // MARK: - Singleton Instance
    static let shared = LocationPermissionManager()
    
    // MARK: - Private Properties
    private let locationManager = CLLocationManager()
    private var locationCompletionHandler: ((CLLocation?) -> Void)?
    
    // MARK: - Initialization
    private override init() {
        super.init()
        locationManager.delegate = self
    }
    
    // MARK: - Request Location Permission
    func requestLocationPermission(completion: @escaping (Bool) -> Void) {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            // Handle completion in delegate methods
        case .restricted, .denied:
            completion(false)
        case .authorizedAlways, .authorizedWhenInUse:
            completion(true)
        @unknown default:
            completion(false)
        }
    }
    
    // MARK: - Request Current Location
    func requestCurrentLocation(completion: @escaping (CLLocation?) -> Void) {
        locationCompletionHandler = completion
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        case .notDetermined:
            requestLocationPermission { granted in
                if granted {
                    self.locationManager.requestLocation()
                } else {
                    self.locationCompletionHandler?(nil)
                }
            }
        case .restricted, .denied:
            self.locationCompletionHandler?(nil)
        @unknown default:
            self.locationCompletionHandler?(nil)
        }
    }
    
    // MARK: - CLLocationManagerDelegate Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.last else {
            locationCompletionHandler?(nil)
            return
        }
        locationCompletionHandler?(latestLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
        locationCompletionHandler?(nil)
    }
    
    // MARK: - Private Properties
    private var completionHandler: ((Bool) -> Void)?
}
