//
//  MapTabModel.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 26.07.2021.
//

import Foundation
import MapKit
import CoreLocation

class MapTabModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var waypoints = [Waypoint]()
    @Published var routeStats = [RouteStat]()
    
    // MARK: - Geolocation tracking
    
    @Published var authorizationState = CLAuthorizationStatus.notDetermined
    
    @Published var placemark: CLPlacemark?
    
    var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        
        // set content model as a delegate of the location manager
        locationManager.delegate = self
    }
    
    func requestGeolocationPermission() {
        // Request permission
        locationManager.requestWhenInUseAuthorization()
    }
    
    // MARK: - LocationManagerDelegate methods
    
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
    
    // Gives us the location of the user
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations.first ?? "no location")
        
        if let userLocation = locations.first {
            // We need it once, so stop requesting the location after we get it once
            locationManager.stopUpdatingLocation()
            
            // Get the placemark of the user
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(userLocation) { placemarks, error in
                print(placemarks)
                print(error)
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

struct Waypoint {
    var kind: Waypoint.Kind
    var label: String?
    var coordinates: CLLocationCoordinate2D?
    var address: [String] = [String]()
    
    enum Kind {
        case myLocation
        case normal
        case destination
    }
}

struct RouteStat {
    weak var device: MobilityDevice?
    
    var distanceKm: Double
    
    var timeH: Double? {
        if let device = device {
            return device.averageSpeedKmh/distanceKm
        }
        return nil
    }
    var batteryPercentage: Double? {
        if let distanceOnFullChargeKm = device?.distanceOnFullChargeKm {
            return distanceKm/distanceOnFullChargeKm
        }
        return nil
    }
}
