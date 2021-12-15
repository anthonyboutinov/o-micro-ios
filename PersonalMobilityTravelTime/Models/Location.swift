//
//  Location.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 28.07.2021.
//

import MapKit

/// A location. It only contains coordinates and a name. Can be initialized from MKMapItem
class Location {
    var name: String?
    var coordinates: Coordinate?
    
    struct Coordinate: Decodable {
        var latitude: Double?
        var longitude: Double?
    }
    
    init(_ mapItem: MKMapItem) {
        self.name = mapItem.name
        self.coordinates = Coordinate(latitude: mapItem.placemark.coordinate.latitude, longitude: mapItem.placemark.coordinate.longitude)
    }
}
