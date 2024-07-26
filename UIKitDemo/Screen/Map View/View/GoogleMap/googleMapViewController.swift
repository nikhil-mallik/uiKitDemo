//
//  googleMapViewController.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 24/07/24.
//

import UIKit
import GoogleMaps
import CoreLocation

class googleMapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var mapBgView: UIView!
    @IBOutlet weak var navigateButton: UIButton!
    let locationManager = CLLocationManager()
    private var googleMapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        geocodeAddress(address: address)
    }
    
    func geocodeAddress(address: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let error = error {
                print("Geocoding failed: \(error.localizedDescription)")
                AlertHelper.showAlert(withTitle: "Alert", message: "Typing mismatch. type Address correct", from: self)
                return
            }
            guard let placemark = placemarks?.first, let coordinate = placemark.location?.coordinate else {
                print("No results found")
                AlertHelper.showAlert(withTitle: "Alert", message: "No results found", from: self)
                return
            }
            DispatchQueue.main.async {
                self.showRouteOnGoogleMap(destinationCoordinate: coordinate, address: address)
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
        
        // Create the path from the current location to the destination
        let path = GMSMutablePath()
        path.add(currentLocation.coordinate)
        path.add(destinationCoordinate)
        
        // Draw the polyline on the map
        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = .blue
        polyline.strokeWidth = 4.0
        polyline.map = googleMapView
        
        // Adjust the camera to show the entire path
        let bounds = GMSCoordinateBounds(path: path)
        googleMapView.animate(with: GMSCameraUpdate.fit(bounds))
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        googleMapView.camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 16)
    }
}


// MARK: - Extension for shared instance
extension googleMapViewController {
    static func sharedInstance() -> googleMapViewController {
        return googleMapViewController.instantiateFromStoryboard("googleMapViewController")
    }
}
