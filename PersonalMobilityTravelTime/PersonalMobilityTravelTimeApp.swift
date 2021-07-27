//
//  PersonalMobilityTravelTimeApp.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 25.07.2021.
//

import SwiftUI
import PartialSheet

@main
struct PersonalMobilityTravelTimeApp: App {
    var body: some Scene {
        WindowGroup {
            LaunchView().environmentObject(ContentModel()).environmentObject(PartialSheetManager())
        }
    }
}
