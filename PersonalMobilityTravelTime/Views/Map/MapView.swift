//
//  MapView.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 26.07.2021.
//

import SwiftUI

struct MapView: View {
    
    @EnvironmentObject var map: MapTabModel
    
    var body: some View {
        // Detect auth status for geolocating
        if map.authorizationState == .notDetermined {
            // If undetermined, show onboarding
            GeolocationOnboardingView()
        }
        else if map.authorizationState == .authorizedAlways || map.authorizationState == .authorizedWhenInUse {
            // If approved
            MapViewContent()
        } else {
            // If denied
            GeolocationDeniedView()
        }
    }
}
