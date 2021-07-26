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

    
    class UI {
        static var deviceIconSize: CGFloat = 28.0
        static var deviceIconSizeLarge: CGFloat = 46.0
        
        static var cornerRadius: CGFloat = 5.0
        
        static var horizontalButtonSpacing: CGFloat = 15.0
        static var verticalButtonSpacing: CGFloat = 6.0
        
        static var sectionSpacing: CGFloat = 30
        static var itemSpacing: CGFloat = 8
        static var horizontalSectionSpacing: CGFloat = 20
    }
    
    class Colors {
        static var quartz =  Color(red:0.965, green:0.965, blue:0.965) // Color(.displayP3, red: 173/255, green: 173/255, blue: 173.255, opacity: 0.1)
    }
}

