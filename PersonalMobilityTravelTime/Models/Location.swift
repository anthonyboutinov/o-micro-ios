//
//  Location.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 28.07.2021.
//

import Foundation

class Location {
    var name: String?
    var coordinates: Coordinate?
    
    struct Coordinate: Decodable {
        var latitude: Double?
        var longitude: Double?
    }
}
