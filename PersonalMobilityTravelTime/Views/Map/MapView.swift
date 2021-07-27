//
//  MapView.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 26.07.2021.
//

import SwiftUI

struct MapView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        // Detect auth status for geolocating
        if model.map.authorizationState == .notDetermined {
            // If undetermined, show onboarding
            GeolocationOnboardingView()
        }
        
        else if model.map.authorizationState == .authorizedAlways || model.map.authorizationState == .authorizedWhenInUse {
            // If approved
            MapViewContent()
        } else {
            // If denied
//            DeniedView()
            GeolocationOnboardingView()
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
