//
//  googlePlaceMapViewController.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 25/07/24.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

class GooglePlaceMapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var mapBgView: UIView!
    @IBOutlet weak var navigateButton: UIButton!
    let locationManager = CLLocationManager()
    private var googleMapView: GMSMapView!
    private var placesClient: GMSPlacesClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placesClient = GMSPlacesClient.shared()
        setupGoogleMapView()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func setupGoogleMapView() {
        if googleMapView == nil {
            googleMapView = GMSMapView(frame: .zero)
            googleMapView.translatesAutoresizingMaskIntoConstraints = false
            mapBgView.addSubview(googleMapView)
            
            NSLayoutConstraint.activate([
                googleMapView.topAnchor.constraint(equalTo: mapBgView.topAnchor),
                googleMapView.bottomAnchor.constraint(equalTo: mapBgView.bottomAnchor),
                googleMapView.leadingAnchor.constraint(equalTo: mapBgView.leadingAnchor),
                googleMapView.trailingAnchor.constraint(equalTo: mapBgView.trailingAnchor)
            ])
            
            googleMapView.isMyLocationEnabled = true
            googleMapView.settings.myLocationButton = true
            googleMapView.delegate = self
        }
    }
    
    @IBAction func navigateButtonTapped(_ sender: UIButton) {
        guard let address = addressTextField.text, !address.isEmpty else { return }
        geocodeAddressGoogle(address: address)
    }
//
//    func geocodeAddressGoogle(address: String) {
//        let placeFields: GMSPlaceField = [.name, .formattedAddress]
//        
//        placesClient.findPlaceLikelihoodsFromCurrentLocation(withPlaceFields: placeFields) { [weak self] (placeLikelihoods, error) in
//            guard let strongSelf = self else { return }
//
//            if let error = error {
//                print("Current place error: \(error.localizedDescription)")
//                return
//            }
//            
//            guard let place = placeLikelihoods?.first?.place else {
//                print("No current place found")
//                return
//            }
//            
//            // Use the details of the current place
//            let coordinate = place.coordinate
//            let address = place.formattedAddress ?? "Unknown address"
//            
//            DispatchQueue.main.async {
//                strongSelf.showRouteOnGoogleMap(destinationCoordinate: coordinate, address: address)
//            }
//        }
//    }

    
    func geocodeAddressGoogle(address: String) {
        
        placesClient.findAutocompletePredictions(fromQuery: address, filter: nil, sessionToken: nil) { (results, error) in
            if let error = error {
                print("Geocoding failed: \(error.localizedDescription)")
                return
            }
            guard let result = results?.first else {
                print("No results found")
                return
            }
            
            self.placesClient.fetchPlace(fromPlaceID: result.placeID, placeFields: .coordinate, sessionToken: nil) { (place, error) in
                if let error = error {
                    print("Fetching place details failed: \(error.localizedDescription)")
                    return
                }
                guard let place = place else {
                    print("No place details found")
                    return
                }
                let coordinate = place.coordinate
                DispatchQueue.main.async {
                    self.showRouteOnGoogleMap(destinationCoordinate: coordinate, address: address)
                }
            }
        }
    }
    
    func showRouteOnGoogleMap(destinationCoordinate: CLLocationCoordinate2D, address: String) {
        guard let currentLocation = locationManager.location else { return }
        
        // Add a marker at the destination
        let marker = GMSMarker(position: destinationCoordinate)
        marker.title = address
        
        marker.icon = GMSMarker.markerImage(with: .red)
        marker.map = googleMapView
        
        let path = GMSMutablePath()
        path.add(currentLocation.coordinate)
        path.add(destinationCoordinate)
        
        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = .blue
        polyline.strokeWidth = 4.0
        polyline.map = googleMapView
        
        let bounds = GMSCoordinateBounds(path: path)
        googleMapView.animate(with: GMSCameraUpdate.fit(bounds))
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        googleMapView.camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 16)
    }
}

// MARK: - Extension for shared instance
extension GooglePlaceMapViewController {
    static func sharedInstance() -> GooglePlaceMapViewController {
        return GooglePlaceMapViewController.instantiateFromStoryboard("GooglePlaceMapViewController")
    }
}


