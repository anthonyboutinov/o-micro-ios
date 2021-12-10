//
//  CalculatorModel.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 28.07.2021.
//

import Foundation
import SwiftUI

class CalculatorModel: ObservableObject {
    
    @Published var distance: Double = 5.0
    
    var averageSpeedKmh: Double = 10.0
    
    @Published var timeToTravelLabel: String = ""
    @Published var timeToTravelUnits: String = ""
    
    func update() {
        let values = self.formattedTimeToTravel()
        self.timeToTravelLabel = values.label
        self.timeToTravelUnits = values.units
    }
    
//    func calculateWith(distance d: Double) -> Self {
//        self.distance = d
//        update()
//        return self
//    }
//
    // Returns time in minutes needed to travel a set distance
    private func timeToTravel(_ distance: Double) -> Double {
        return distance / averageSpeedKmh * 60.0
    }
    
    private func formattedTimeToTravel() -> (label: String, units: String) {
        let timeToTravel = timeToTravel(self.distance)
        let rounded = timeToTravel.rounded()
        if timeToTravel >= 60 {
            let fullHours = floor(rounded / 60)
            let leftoverMinutes = rounded.truncatingRemainder(dividingBy: 60.0)
            if leftoverMinutes < 3 { // if is full hours ±3 min
                return (label: String(format: "%.0f", fullHours), units: Constants.Time.h)
            } else {
                return (label: String(format: "%.0f \(Constants.Time.h) %.0f", fullHours, leftoverMinutes), units: Constants.Time.min)
            }
        } else {
            return (label: String(format: "%.0f", timeToTravel), units: Constants.Time.min)
        }
    }
    
}
