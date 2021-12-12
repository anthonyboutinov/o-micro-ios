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
    
//    @State var location: Location?
    
    @State var distance: Double? = nil
    
    // MARK: UI
        
    enum FocusField: Hashable {
        case destination
        case origin
    }
    
    @FocusState private var focusedField: FocusField?
    
    // MARK: - body
        
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: Constants.UI.itemSpacing) {
                
                DeviceSelectAndSettingsView(distance: self.$distance)
                
                SearchFieldOriginLocation(focusedField: $focusedField)
                
                SearchFieldDestinationLocation(focusedField: $focusedField)
                
            }
            .padding(.horizontal, Constants.UI.horizontalSectionSpacing)
            .padding(.vertical, Constants.UI.verticalSectionSpacing)
            .background(Constants.Colors.mist)
            
            if self.map.completerResults != nil && self.map.state != .destinationSet {
                CompleterResults()
            }
            
            if self.map.state == .initial || self.map.state == .destinationSet {
                DirectionsMap()
                    .frame(maxHeight: .infinity)
            } else if self.map.state == .sentSearchRequest {
                Text("Working on it...")
            } else {
                Spacer()
            }
            
            RouteTimeResultsView(distance: self.$distance)
        }
        .navigationBarTitle("") //this must be empty
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
