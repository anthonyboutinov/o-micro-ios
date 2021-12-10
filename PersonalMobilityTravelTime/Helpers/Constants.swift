//
//  Constants.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 26.07.2021.
//

import Foundation
import SwiftUI

class Constants {
//    static var whereCanBeRidden = WhereCanBeRidden.self
    
//    static var ui = UI.self
    
    class WhereCanBeRidden {
        static var pedestrianPaths = "Pedestrian"
        static var carRoads = "Car Roads"
    }
    
    class Text {
        static var searchPlaceholder = "Search by Name or Address"
    }

    
    class UI {
        static var deviceIconSize: CGFloat = 28.0
        static var deviceIconSizeLarge: CGFloat = 46.0
        
        static var cornerRadius: CGFloat = 5.0
        
        static var horizontalButtonSpacing: CGFloat = 15
        static var verticalButtonSpacing: CGFloat = 12
        static var deviceIconVerticalPaddingInButtons: CGFloat = -6
        
        static var sectionSpacing: CGFloat = 30
        static var compactSpacing: CGFloat = 10
        static var itemSpacing: CGFloat = 8
        static var horizontalSectionSpacing: CGFloat = 18
        static var verticalSectionSpacing: CGFloat = 12
        static var sheetBottomPadding: CGFloat = 12
        
    }
    
    class Colors {
        static var quartz = Color(red:0.965, green:0.965, blue:0.965) // Color(.displayP3, red: 173/255, green: 173/255, blue: 173.255, opacity: 0.1)
        static var graphite = Color(red:0.427, green:0.447, blue:0.471)
        static var mist = Color(red:0.957, green:0.957, blue:0.957)
    }
    
    static let allIcons = [
        "022-electricscooter",
        "020-scooter",
        "023-scooterwithaseat",
        
        "028-bycicle",
        "030-bike",
        
        "027-moped",
        "021-motorbike",
        
        "025-segway",
        "026-one wheel",
        
        "037-skateboard",
        "038-longboard",
        "036-rollerskate",
        
        "024-hoverboard",
        "031-jetpack"
    ]
    
    enum SearchbarIcons: String {
        case circle = "Circle"
        case currentLocation = "Current Location"
        case destination = "Destination"
        case magnifyingGlass = "Magnifying Glass"
    }
    
    struct Time {
        static let min = "min"
        static let h = "h"
    }
    
    struct CalculatorUI {
        static let batteryUsageDangerPercentage = 0.93
        static let batteryUsageWarningPercentage = 0.46
        static let maxOptionsForMapView = 3
    }
}

