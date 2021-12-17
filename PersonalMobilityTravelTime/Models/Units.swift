//
//  Units.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony van den Brandt on 17.12.2021.
//

import Foundation

/// Units of distance: Metric and Imperial
enum Units: String, Identifiable {
    var id: Self { self }
    
    case metric
    case imperial
    
    static var all: [Units] {
        return [.metric, .imperial]
    }
    
    /// Returns short localized string description
    var name: String {
        switch self {
        case .metric: return String(localized: "km")
        case .imperial: return String(localized: "miles")
        }
    }
    
    /// Returns the localized name of the units
    var optionTitle: String {
        switch self {
        case .metric: return String(localized: "Kilometers")
        case .imperial: return String(localized: "Miles")
        }
    }
    
    /// Returns the localized string of \unit per hour
    var perHour: String {
        switch self {
        case .metric: return String(localized: "km/h")
        case .imperial: return String(localized: "mph")
        }
    }
    }
