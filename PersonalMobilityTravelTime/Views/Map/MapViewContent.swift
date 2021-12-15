//
//  MapViewContent.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 26.07.2021.
//

import SwiftUI
import MapKit

struct MapViewContent: View {
    
    @EnvironmentObject var model: ContentModel
    @EnvironmentObject var map: MapTabModel
    
    enum FocusField: Hashable {
        case destination
        case origin
        case map
    }
    
    @FocusState private var focusedField: FocusField?
    
    // MARK: - body
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            if self.focusedField != .map {
                VStack(alignment: .leading, spacing: Constants.UI.itemSpacing) {
                    
                    DeviceSelectAndSettingsView(distance: self.$map.routeDistances[self.model.selectedDevice!.transportType], state: self.$map.state, focusedField: self.$focusedField)
                    
                    SearchFieldOriginLocation(focusedField: $focusedField)
                    
                    SearchFieldDestinationLocation(focusedField: $focusedField)
                    
                }
                .padding(.horizontal, Constants.UI.horizontalSectionSpacing)
                .padding(.vertical, Constants.UI.verticalSectionSpacing)
                .background(Constants.Colors.mist)
                
                if self.map.completerResults != nil && self.map.state != .destinationSet && self.map.state != .initial {
                    CompleterResults()
                }
            }
            
            if self.map.state == .initial || self.map.state == .destinationSet {
                DirectionsMap()
                    .onTapGesture {
                        // If displaying route and user taps on the map, enter "full screen" mode
                        if self.map.state == .destinationSet {
                            if self.focusedField == .map {
                                self.focusedField = nil
                            } else {
                                self.focusedField = .map
                            }
                        }
                    }
            } else {
                Spacer()
            }
            
            if self.map.state == .destinationSet && !self.map.routeDistances.isEmpty {
                RouteTimeResultsView(distances: self.$map.routeDistances, isExpanded: self.$map.routeTimeResultsAreExpanded)
            }
        }
        .navigationBarTitle("Map") //this must be empty or set to something
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct MapViewContent_Previews: PreviewProvider {
    static var previews: some View {
        MapViewContent()
            .environmentObject(ContentModel())
            .environmentObject(MapTabModel())
    }
}
