//
//  MapViewContent.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 26.07.2021.
//

import SwiftUI
import MapKit

struct MapViewContent: View {
    
    @State var location: Location?
    
    @State var searchQueryLabel: String = ""
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: Constants.UI.itemSpacing) {
                
                HStack {
                    DeviceSelector()
                    
                    NavigationLink("Settings", destination: SettingsView())
                        .padding(.vertical, Constants.UI.verticalButtonSpacing)
                }
                
                HStack {
                    Image(Constants.SearchbarIcons.magnifyingGlass.rawValue)
                    TextField("Search by Name or Address", text: $searchQueryLabel)
                }
                .modifier(InputFieldViewModifier(style: .alternate))
            }
            .padding(.horizontal, Constants.UI.horizontalSectionSpacing)
            .padding(.vertical, Constants.UI.verticalSectionSpacing)
            .background(Constants.Colors.mist)
            
            DirectionsMap(location: location)
//                .ignoresSafeArea()
        }
        .navigationBarHidden(true)
    }
}

struct MapViewContent_Previews: PreviewProvider {
    static var previews: some View {
        MapViewContent()
            .environmentObject(ContentModel())
    }
}
