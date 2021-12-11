//
//  MapTabModel.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 26.07.2021.
//

import Foundation
import MapKit
import CoreLocation

class MapTabModel: NSObject, ObservableObject {
    
    @Published var waypoints = [Waypoint]()
//    @Published var routeStats = [RouteStat]()
    
    // MARK: - Geolocation tracking
    
    @Published var authorizationState = CLAuthorizationStatus.notDetermined
    
    @Published var placemark: CLPlacemark?
    
    var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        
        // set this view model as a delegate of the location manager
        locationManager.delegate = self
        
        setUpSearchCompleter()
    }
    
    func requestGeolocationPermission() {
        // Request permission
        locationManager.requestWhenInUseAuthorization()
    }
    
    // MARK: Suggestions
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchRegion = MKCoordinateRegion(MKMapRect.world)
    var currentPlacemark: CLPlacemark?
    
    @Published var completerResults: [MKLocalSearchCompletion] = [MKLocalSearchCompletion]()
    
    private func setUpSearchCompleter() {
        searchCompleter.delegate = self
        searchCompleter.resultTypes = [.address, .pointOfInterest]
        searchCompleter.region = searchRegion
    }
    
    func updatePlacemark(_ placemark: CLPlacemark?, boundingRegion: MKCoordinateRegion) {
        currentPlacemark = placemark
        searchCompleter.region = searchRegion
    }
    
}

// MARK: - LocationManagerDelegate methods
extension MapTabModel: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        // Update the auth state property
        self.authorizationState = locationManager.authorizationStatus
        
        if locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse {
            // We have permission here
            // Start geolocating after getting permission
            locationManager.startUpdatingLocation()
            
        } else if locationManager.authorizationStatus == .denied {
            // We don't have permission
            
        } else if locationManager.authorizationStatus == .restricted {
            // Restricted in Settings
            
        }
    }
    
    /// Gives us the location of the user
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations.first ?? "no location")
        
        if let userLocation = locations.first {
            // We need it once, so stop requesting the location after we get it once
            locationManager.stopUpdatingLocation()
            
            // Get the placemark of the user
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(userLocation) { placemarks, error in
                print(placemarks ?? "no placemarks")
                print(error ?? "no error")
                if error == nil {
                    // Take the first placemark
                    self.placemark = placemarks?.first
                }
            }
            
            // TODO: Send to Apple Maps API
            // userlocation
        }
        
    }
}

// MARK: - SearchCompleterDelegate methods
extension MapTabModel: MKLocalSearchCompleterDelegate {
    
    /// - Tag: QueryResults
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
//        print("completerDidUpdateResults with results: \(completer.results)")
        // As the user types, new completion suggestions are continuously returned to this method.
        // Overwrite the existing results, and then refresh the UI with the new results (@Published does that)
        completerResults = completer.results
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // Handle any errors returned from MKLocalSearchCompleter.
        if let error = error as NSError? {
            print("MKLocalSearchCompleter encountered an error: \(error.localizedDescription). The query fragment is: \"\(completer.queryFragment)\"")
        }
    }
}



struct Waypoint {
    var kind: Waypoint.Kind
    var label: String?
    var coordinates: CLLocationCoordinate2D?
    var address: [String] = [String]()
    
    enum Kind {
        case currentLocation
        case normal
        case destination
    }
}
