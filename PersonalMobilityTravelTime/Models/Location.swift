//
//  Location.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 28.07.2021.
//

import MapKit

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
