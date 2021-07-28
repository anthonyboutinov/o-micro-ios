//
//  CalculatorModel.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 28.07.2021.
//

import Foundation
import SwiftUI

class CalculatorModel: ObservableObject {
    
    @Published var distance: Double = 5
    
    var distanceProxy: Binding<String> {
        Binding<String>(
            get: {
                String(Double(self.distance).removeZerosFromEnd(leaveFirst: 2))
            },
            set: {
                if !($0.last == "." || $0.last == ",") {
                    if let value = self.numberFomatter.number(from: $0) {
                        self.distance = value.doubleValue
                        self.update()
                    }
                }
            }
        )
    }
    
    private var numberFomatter: NumberFormatter = {
        let f = NumberFormatter()
        f.isLenient = true
        f.numberStyle = .none
        f.maximumFractionDigits = 1
        f.minimumFractionDigits = 0
        f.alwaysShowsDecimalSeparator = false
        return f
    }()
    
    var averageSpeedKmh: Double = 10
    
    @Published var timeToTravelLabel: String = ""
    @Published var timeToTravelUnits: String = ""
    
    func update() {
        let values = self.formattedTimeToTravel()
        self.timeToTravelLabel = values.label
        self.timeToTravelUnits = values.units
    }
    
    private func timeToTravel(_ distance: Double) -> Double {
        return distance / averageSpeedKmh * 60.0
    }
    
    private func formattedTimeToTravel() -> (label: String, units: String) {
        let minutesLabel = "min"
        let hoursLabel = "h"
        let timeToTravel = timeToTravel(self.distance)
        let rounded = timeToTravel.rounded()
        if timeToTravel >= 60 {
            let fullHours = floor(rounded / 60)
            let leftoverMinutes = rounded.truncatingRemainder(dividingBy: 60.0)
            if leftoverMinutes < 3 { // if is full hours ±3 min
                return (label: String(format: "%.0f", fullHours), units: hoursLabel)
            } else {
                return (label: String(format: "%.0f h %.0f", fullHours, leftoverMinutes), units: minutesLabel)
            }
        } else {
            return (label: String(format: "%.0f", timeToTravel), units: minutesLabel)
        }
    }
    
}
