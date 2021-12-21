//
//  CalculatorModel.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 28.07.2021.
//

import Foundation
import SwiftUI

/// View model that controls the Calculator tab
final class CalculatorModel: ObservableObject {
    
    @Published var distance: Double {
        didSet {
            update()
        }
    }
    
    private var averageSpeedKmh: Double
    
    /// Is nil when the device is not electric
    private var batteryRange: Double?
    
    @Published var timeToTravelLabel: String = ""
    @Published var timeToTravelUnits: String = ""
    
    @Published var batteryUsageLabel: String = ""
    
    init(averageSpeedKmh: Double, batteryRange: Double?, distance: Double) {
        self.averageSpeedKmh = averageSpeedKmh
        self.batteryRange = batteryRange
        self.distance = distance
        update()
    }
    
    private func update() {
        let (label, units) = self.formattedTimeToTravel()
        self.timeToTravelLabel = label
        self.timeToTravelUnits = units
        
        if let usage = self.batteryUsage() {
            self.batteryUsageLabel = String(Int(usage * 100))
        }
    }
    
    /// Returns time in minutes needed to travel a set distance
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
                return (label: String(format: "%.0f", fullHours), units: String(localized: "h"))
            } else {
                return (label: String(format: "%.0f \(String(localized: "h")) %.0f", fullHours, leftoverMinutes), units: String(localized: "min"))
            }
        } else {
            return (label: String(format: "%.0f", timeToTravel), units: String(localized: "min"))
        }
    }
    
    private func batteryUsage() -> Double? {
        if let batteryRange = batteryRange {
            return distance / batteryRange
        }
        return nil
    }
    
}
