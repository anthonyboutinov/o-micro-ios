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
    
    enum ViewState: Hashable {
        case initial
        case focusedOnEnteringDestination
        case enteringDestination
        case sentSearchRequest
        case destinationSet
    }
    
    @Published var state = ViewState.initial {
        didSet {
            if state == .initial {
                reset()
            }
        }
    }
    
    @Published var destinationLabel: String = ""
    
    @Published var waypoints = [Waypoint]()
    
    enum OriginPointState: Hashable {
        case currentLocation
        case otherLocation
    }
    @Published var originPointState = OriginPointState.currentLocation
    @Published var originLabel: String = Constants.Text.currentLocationLabel
    
    /// For each type of TransportType that the user's devices have stores route distance in kilometers
    @Published var routeDistances = [MobilityDevice.TransportType: Double]()
    
    /// A boolean flag for toggling between compact view (limited to ~3 devices) and full view for RouteTimeResultsView
    @Published var routeTimeResultsAreExpanded = false
    
    /// Allows the map view to register when transportationType to draw changes, so it can clear it's content and recalculate routes
    @Published var displayingRouteForTransportType: MobilityDevice.TransportType? {
        didSet {
            print("displayingRouteForTransportType didSet to \(self.displayingRouteForTransportType.debugDescription)")
        }
    }
    
    private func reset() {
        destinationLabel = ""
        originPointState = OriginPointState.currentLocation
        originLabel = Constants.Text.currentLocationLabel
        routeDistances.removeAll()
        completerResults = nil
        localSearch = nil // sets places to nil as well
        location = nil
        routeTimeResultsAreExpanded = false
        displayingRouteForTransportType = nil
    }
    
    // MARK: - Geolocation tracking
    
    @Published var authorizationState = CLAuthorizationStatus.notDetermined
    
    @Published var currentPlacemark: CLPlacemark?
    
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
    private var searchRegion = MKCoordinateRegion(MKMapRect.world)
    
    @Published var completerResults: [MKLocalSearchCompletion]?
    
    private func setUpSearchCompleter() {
        searchCompleter.delegate = self
        searchCompleter.resultTypes = [.address, .pointOfInterest]
        searchCompleter.region = searchRegion
    }
    
//    func updatePlacemark(_ placemark: CLPlacemark?, boundingRegion: MKCoordinateRegion) {
//        currentPlacemark = placemark
//        searchCompleter.region = searchRegion
//    }
    
    // MARK: - Search Requests
    
    @Published var places: [MKMapItem]? {
        didSet {
            self.completerResults = nil
            if let place = self.places?.first {
                self.location = Location(place)
                
            }
        }
    }
    
    @Published var location: Location? {
        didSet {
            if let location = location {
                self.state = .destinationSet
                self.destinationLabel = location.name ?? "[no name]"
            }
        }
    }
    
    private var boundingRegion: MKCoordinateRegion = MKCoordinateRegion(MKMapRect.world) {
        didSet {
            searchCompleter.region = boundingRegion
        }
    }
    private var localSearch: MKLocalSearch? {
        willSet {
            // Clear the results and cancel the currently running local search before starting a new search.
            places = nil
            localSearch?.cancel()
        }
    }
    
    /// - Parameter suggestedCompletion: A search completion provided by `MKLocalSearchCompleter` when tapping on a search completion table row
    func search(for suggestedCompletion: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: suggestedCompletion)
        search(using: searchRequest)
    }
    
    /// - Parameter queryString: A search string from the text the user entered
    func search(for queryString: String?) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = queryString
        search(using: searchRequest)
    }
    
    /// Search for places. Updates self.places with [MKMapItem]
    /// - Tag: SearchRequest
    private func search(using searchRequest: MKLocalSearch.Request) {
        // Confine the map search area to an area around the user's current location.
        searchRequest.region = boundingRegion
        
        searchRequest.resultTypes = [.pointOfInterest, .address]
        
        localSearch = MKLocalSearch(request: searchRequest)
        localSearch?.start { [unowned self] (response, error) in
            guard error == nil else {
                self.displaySearchError(error)
                return
            }
            
            self.places = response?.mapItems
            
            // Used when setting the map's region in `prepareForSegue`. // ???
            if let updatedRegion = response?.boundingRegion {
                self.boundingRegion = updatedRegion
            }
        }
    }
    
    private func displaySearchError(_ error: Error?) {
        print("displaySearchError with error \(error.debugDescription)")
//        if let error = error as NSError?, let errorString = error.userInfo[NSLocalizedDescriptionKey] as? String {
//            let alertController = UIAlertController(title: "Could not find any places.", message: errorString, preferredStyle: .alert)
//            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            present(alertController, animated: true, completion: nil)
//        }
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
                    self.currentPlacemark = placemarks?.first
                    self.boundingRegion = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 12_000, longitudinalMeters: 12_000)
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
