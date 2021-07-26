//
//  MapTabModel.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 26.07.2021.
//

import Foundation
import MapKit

class MapTabModel: ObservableObject {
    @Published var waypoints = [Waypoint]()
    
    @Published var routeStats = [RouteStat]()
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
