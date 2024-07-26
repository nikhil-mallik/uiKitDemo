//
//  MapIntregationViewController.swift
//  UIKitDemo
//
//  Created by Nikhil Mallik on 24/07/24.
//

import UIKit
import MapKit
import CoreLocation

class AppleMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var navigateButton: UIButton!
    @IBOutlet weak var showMapView: MKMapView!
    
    // MARK: - Properties
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setupLocationManager()
    }
    // MARK: - Setup Methods
    private func setupMapView() {
        showMapView.delegate = self
        showMapView.showsUserLocation = true
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - Actions
    @IBAction func navigateButtonAction(_ sender: Any) {
        guard let address = addressTextField.text, !address.isEmpty else { return }
        geocodeAddress(address: address)
    }
    
    // MARK: - Geocoding
    func geocodeAddress(address: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { [weak self] (placemarks, error) in
            guard let self = self, let placemark = placemarks?.first, let location = placemark.location else { return }
            let coordinate = location.coordinate
            self.addDestinationAnnotation(coordinate: coordinate, address: address)
            self.showRouteOnMap(destinationCoordinate: coordinate)
        }
    }
    
    // MARK: - Map Methods
    private func addDestinationAnnotation(coordinate: CLLocationCoordinate2D, address: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = address
        annotation.subtitle = formatDistanceForDisplay(calculateDistance(from: showMapView.userLocation.coordinate, to: coordinate))
        showMapView.addAnnotation(annotation)
    }
    
    func calculateDistance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        let Fromlocation = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let Tolocation = CLLocation(latitude: to.latitude, longitude: to.longitude)
        
        return Fromlocation.distance(from: Tolocation)
    }
    
    func formatDistanceForDisplay(_ distance: CLLocationDistance) -> String {
        let meters = Measurement(value: distance, unit: UnitLength.meters)
        
        if #available(iOS 15.0, *) {
            
            return meters.converted(to: .kilometers).formatted()
            
        } else {
            
            let distanceFormatter = MeasurementFormatter()
            distanceFormatter.unitOptions = .providedUnit
            let measurement = Measurement(value: distance, unit: UnitLength.kilometers)
            return distanceFormatter.string(from: measurement)
        }
    }
    
    func showRouteOnMap(destinationCoordinate: CLLocationCoordinate2D) {
        guard let currentLocation = showMapView.userLocation.location else { return }
        
        let sourceCoordinate = currentLocation.coordinate
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                    AlertHelper.showAlert(withTitle: "Alert", message: "Typing mismatch. Write proper address", from: self)
                }
                return
            }
            
            let route = response.routes[0]
            self.showMapView.addOverlay(route.polyline, level: .aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.showMapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }
    
    // MARK: - MKMapViewDelegate
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .blue
        renderer.lineWidth = 4.0
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil // Use default blue dot for user location
        } else {
            let identifier = "DestinationMarker"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView!.canShowCallout = true
                (annotationView as! MKPinAnnotationView).pinTintColor = .red
            } else {
                annotationView!.annotation = annotation
            }
            
            return annotationView
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            showMapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user's location: \(error.localizedDescription)")
    }
}

// MARK: - Extension for shared instance
extension AppleMapViewController {
    static func sharedInstance() -> AppleMapViewController {
        return AppleMapViewController.instantiateFromStoryboard("AppleMapViewController")
    }
}
