//
//  MobilityDevice.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 26.07.2021.
//

import Foundation

class MobilityDevice: Identifiable {
    
    var id: UUID = UUID()
    var index: Int
    
    var title: String
    var iconName: String
    var isElectric: Bool = false
    var averageSpeedCalculatorData: AverageSpeedCalculatorData?
    var averageSpeedKmh: Double
    var distanceOnFullChargeKm: Double?
    var whereCanBeRidden = [String]()
    
    init(id: UUID, index: Int, title: String, iconName: String, isElectric: Bool, averageSpeedKmh: Double, distanceOnFullChargeKm: Double?, whereCanBeRidden: [String]) {
        self.id = id
        self.index = index
        self.title = title
        self.iconName = iconName
        self.isElectric = isElectric
        self.averageSpeedKmh = averageSpeedKmh
        self.distanceOnFullChargeKm = distanceOnFullChargeKm
        self.whereCanBeRidden = whereCanBeRidden
    }
    
    static func sample() -> MobilityDevice {
        return MobilityDevice(id: UUID(), index: 0, title: "Ninebot ES1", iconName: "022-electricscooter", isElectric: true, averageSpeedKmh: 10.8, distanceOnFullChargeKm: 14.5, whereCanBeRidden: [Constants.WhereCanBeRidden.pedestrianPaths])
    }
    
}

struct AverageSpeedCalculatorData {
    var distanceKm: Double
    var travelTimeH: Double
}
