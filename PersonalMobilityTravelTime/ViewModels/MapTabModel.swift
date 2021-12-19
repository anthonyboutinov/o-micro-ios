//
//  MapTabModel.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 26.07.2021.
//

import Foundation
import MapKit

/// View model that controls the Map tab
final class MapTabModel: NSObject, ObservableObject {
    
    /// Handles the progression of setting up the start location and the end location.
    /// We start in an inital, blank state. Then the user clicks on destination location input field.
    /// He is presented with options. When he clicks one, we send a request for this location
    /// and in the callback we set the destination. When that is done, start location input field
    /// is shown with the default value being `Current Location`. If the user wants to change
    /// that, he can do the same thing with the start location.
    enum ViewState: Int, Hashable, Comparable {
        case initial
        
        case focusedOnEnteringEndLocation
        case enteringEndLocation
        case sentSearchRequestForEndLocation
        case endLocationIsSet
        
        case focusedOnEnteringStartLocation
        case enteringStartLocation
        case sentSearchRequestForStartLocation
        case startLocationIsSet
        
        static func < (lhs: MapTabModel.ViewState, rhs: MapTabModel.ViewState) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
    }
    
    @Published var state = ViewState.initial {
        didSet {
            if state == .initial {
                reset()
            }
        }
    }
    
    @Published var destinationLabel: String = ""
    
//    @Published var waypoints = [Waypoint]()
    
    enum OriginPointState: Hashable {
        case currentLocation
        case otherLocation
    }
    @Published var originPointState = OriginPointState.currentLocation
    @Published var originLabel: String = String(localized: "Current Location") {
        didSet {
            if originLabel == String(localized: "Current Location") {
                originPointState = .currentLocation
            } else {
                originPointState = .otherLocation
            }
        }
    }
    
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
    
    /// Resets MapTabModel
    private func reset() {
        destinationLabel = ""
        originPointState = OriginPointState.currentLocation
        originLabel = String(localized: "Current Location")
        routeDistances.removeAll()
        completerResults = nil
        localSearch?.cancel()
        localSearch = nil
        endLocation = nil
        startLocation = nil
        routeTimeResultsAreExpanded = false
        displayingRouteForTransportType = nil
    }
    
    // MARK: - Geolocation tracking
    
    /// Geolocation tracking authorization state
    @Published var authorizationState = CLAuthorizationStatus.notDetermined
        
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
    
    /// Used by DirectionsMap to create a route: end location
    @Published var endLocation: Location? {
        didSet {
            if let location = endLocation {
                self.state = .endLocationIsSet
                self.destinationLabel = location.name ?? "[no name]"
            }
        }
    }
    
    /// Used by DirectionsMap to create a route: start location
    @Published var startLocation: Location? {
        didSet {
            if let originLocation = startLocation {
                self.state = .startLocationIsSet
                self.originLabel = originLocation.name ?? "[no name]"
            }
        }
    }
    
    private var boundingRegion: MKCoordinateRegion = MKCoordinateRegion(MKMapRect.world) {
        didSet {
            searchCompleter.region = boundingRegion
        }
    }
    
    /// A handle for the MKLocalSearch async request. Needed so that it can be accessed while it's running to cancel it if nesessary
    private var localSearch: MKLocalSearch? {
        willSet {
            // Clear the results and cancel the currently running local search before starting a new search.
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
            
            self.completerResults = nil
            
            // All places that are given in the response.
            let places = response?.mapItems
            
            // But because of how the UI is made, a user cannot invoke search by himself,
            // he can only select from pre-queried options. So we expect a one to one
            // correspondence of the search request with the list of results. This allows
            // us to assume that there is only one `places` item.
            if let place = places?.first {
                if self.state == .sentSearchRequestForEndLocation || self.state == .enteringEndLocation {
                    self.endLocation = Location(place)
                } else if self.state == .sentSearchRequestForStartLocation || self.state == .enteringStartLocation {
                    self.startLocation = Location(place)
                }
            }
            
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

//    /// Gives us the location of the user
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print(locations.first ?? "no location")
//
//        if let userLocation = locations.first {
//            // We need it once, so stop requesting the location after we get it once
//            locationManager.stopUpdatingLocation()
//
//            // Get the placemark of the user
//            let geocoder = CLGeocoder()
//            geocoder.reverseGeocodeLocation(userLocation) { placemarks, error in
//                print(placemarks ?? "no placemarks")
//                print(error ?? "no error")
//                if error == nil {
//                    // Take the first placemark
//                    self.currentPlacemark = placemarks?.first
//                    self.boundingRegion = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 12_000, longitudinalMeters: 12_000)
//                }
//            }
//
//            // TODO: Send to Apple Maps API
//            // userlocation
//        }
//
//    }
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



//struct Waypoint {
//    var kind: Waypoint.Kind
//    var label: String?
//    var coordinates: CLLocationCoordinate2D?
//    var address: [String] = [String]()
//
//    enum Kind {
//        case currentLocation
//        case normal
//        case destination
//    }
//}
