//
//  Constants.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 26.07.2021.
//

import Foundation
import SwiftUI

class Constants {
    
//    class Text {
////        static var currentLocationLabel = "Current Location"
//
//        static var settings = String(localized: "Settings")
//        static var cancel = String(localized: "Cancel")
//        static var done = String(localized: "Done")
//        static var delete = String(localized: "Delete")
//        static var reorder = String(localized: "Reorder")
//    }

    
    class UI {
        static var deviceIconSize: CGFloat = 28.0
        static var deviceIconSizeLarge: CGFloat = 46.0
        static var deviceSelectorItemSpacing: CGFloat = 15
        
        static var cornerRadius: CGFloat = 12
        
        static var horizontalButtonSpacing: CGFloat = 15
        static var verticalButtonSpacing: CGFloat = 12
        static var deviceIconVerticalPaddingInButtons: CGFloat = -6
        
        static var sectionSpacing: CGFloat = 30
        static var compactSpacing: CGFloat = 10
        static var itemSpacing: CGFloat = 8
        static var horizontalSectionSpacing: CGFloat = 18
        static var verticalSectionSpacing: CGFloat = 12
        static var sheetBottomPadding: CGFloat = 12
        
        static var mapEdgeInsetsVertical: CGFloat = 80
        static var mapEdgeInsetsHorizontal: CGFloat = 30
        
        static var unitsMinWidth: CGFloat = 41
        static var systemFontDefaultSize: CGFloat = 16
        
        static var onboardingButtonsBottomPadding: CGFloat = 24
        
        static var onboardingItemSpacing: CGFloat = 30
        
    }
    
    class Colors {
        static var quartz = Color("QuartzColor")
        static var mist = Color("MistColor")
        static var transparent = Color("TransparentColor")
        static var red = Color("RedColor")
        static var orange = Color("OrangeColor")
        static var textFieldAlternateBackgroundColor = Color("textFieldAlternateBackgroundColor")
        
        static var route = UIColor(Color("RouteColor"))
        
        static var primaryGradient = Gradient(colors: [Color("GradientLighterColor"), Color("GradientDarkerColor")])
        static var redGradient = Gradient(colors: [Color("RedGradientLighterColor"), Color("RedGradientDarkerColor")])
    }
    
    static let allIcons = [
        "022-electricscooter",
        "020-scooter",
        "023-scooterwithaseat",
        
        "100-omafiets",
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
    
    struct CalculatorUI {
        static let batteryUsageDangerPercentage = 0.93
        static let batteryUsageWarningPercentage = 0.46
        static let maxOptionsForMapView = 3
    }
}

