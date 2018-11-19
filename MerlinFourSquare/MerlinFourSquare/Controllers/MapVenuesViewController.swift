//
//  MapVenuesViewController.swift
//  MerlinFourSquare
//
//  Created by Gonzalinho on 11/18/18.
//  Copyright © 2018 Gonzalinho. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreData

struct MapVenuesViewControllerConfig {
    static let acceptButton = "OK"
    static let locationPermissionTitle = "Location permission"
    static let locationPermissionMessage = "Please enable location permission and try again"
    static let meText = "Me"
}

class MapVenuesViewController: UIViewController {
    @IBOutlet weak var mapView: GMSMapView!
    
    var currentLocation: CLLocation?
    
    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .other
        return locationManager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func presentLocationPermissionAlert() {
        let okAction = UIAlertAction(title: MapVenuesViewControllerConfig.acceptButton, style: .default) { (alertAction) in
            self.backPreviousController()
        }
        presentAlertController(title: MapVenuesViewControllerConfig.locationPermissionTitle,
                               message: MapVenuesViewControllerConfig.locationPermissionMessage,
                               actions: [okAction])
    }
    
    private func setupInterface() {
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.7)
    }
    
    private func setupData() {
        guard let location = currentLocation else { return }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        FourSquareAPI().fetchNearbyMapVenues(location: location) { (responseVenues, error) in
             UIApplication.shared.isNetworkActivityIndicatorVisible = false
            guard
                let venues = responseVenues
            else {
                print("Error")
                return
            }
            
            self.createMarkersFromVenuesData(venues: venues)
        }
    }
    
    private func createMarkersFromVenuesData(venues: [Venue]) {
        for venue in venues {
            let location = CLLocation(latitude: venue.location.lat, longitude: venue.location.lng)
            self.createMarker(location: location, title: venue.name)
        }
    }
    
    private func setupGoogleMaps() {
        guard let location = currentLocation else { return }
        startGoogleMaps(location: location, headerViewFrame: mapView.bounds)
        setupCurrentUserMarker(location: location)
    }
    
    func startGoogleMaps(location: CLLocation, headerViewFrame: CGRect) {
        let circleRadius = GMSCircle(position: location.coordinate, radius: 300)
        let zoom = calculateZoom(size: headerViewFrame.size, radius: CGFloat(circleRadius.radius))
        
        mapView.camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: zoom)
    }
    
    private func calculateZoom(size: CGSize, radius: CGFloat) -> Float {
        let equatorLength = 40075004// in Meters
        let widthInPixels = size.height
        var metersPerPixel = CGFloat(equatorLength / 256)
        var zoomLevel = Float(1)
        
        while ((metersPerPixel * widthInPixels) > radius * 10) {
            metersPerPixel /= 2
            zoomLevel += 1
        }
        
        return zoomLevel
    }
    
    private func setupCurrentUserMarker(location: CLLocation) {
        let marker = GMSMarker()
        marker.position = location.coordinate
        marker.title = MapVenuesViewControllerConfig.meText
        marker.icon = GMSMarker.markerImage(with: .blue)
        marker.map = mapView
    }
    
    private func createMarker(location: CLLocation, title: String) {
        let marker = GMSMarker()
        marker.position = location.coordinate
        marker.title = title
        marker.icon = GMSMarker.markerImage(with: .cyan)
        marker.appearAnimation = .pop
        marker.map = mapView
    }
    
    private func backPreviousController() {
        navigationController?.popViewController(animated: true)
    }
}

extension MapVenuesViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        if currentLocation == nil {
            currentLocation = location
            setupGoogleMaps()
            setupData()
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            presentLocationPermissionAlert()
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        }
    }
}
