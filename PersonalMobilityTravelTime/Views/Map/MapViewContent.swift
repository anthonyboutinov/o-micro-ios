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
    
    @State var location: Location?
    
    @State var destinationLabel: String = ""
    @State var originLabel: String = "Current Location"
    
    @State var distance: Double? = 19.3
    
    enum ViewState: Hashable {
        case initial
        case enteringDestination
        case destinationEntered
    }
    
    @State var state = ViewState.initial
    
    enum OriginPointState: Hashable {
        case currentLocation
        case otherLocation
    }
    
    @State var originPointState = OriginPointState.currentLocation
    
    enum FocusField: Hashable {
        case destination
        case origin
    }
    
    @FocusState private var focusedField: FocusField?
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: Constants.UI.itemSpacing) {
                
                DeviceSelectAndSettingsView(distance: self.$distance)
                
                if (self.state == .destinationEntered) {
                    HStack {
                        Image(self.originPointState == .currentLocation ? Constants.SearchbarIcons.currentLocation.rawValue : Constants.SearchbarIcons.circle.rawValue)
                        TextField("Search by Name or Address", text: $originLabel)
                            .focused($focusedField, equals: .origin)
                    }
                    .modifier(InputFieldViewModifier(style: .alternate))
                    .foregroundColor(self.originPointState == .currentLocation ? .gray : .black)
                    .onTapGesture {
                        self.focusedField = .origin
                    }
                }
                
                HStack {
                    Image(self.state != .destinationEntered ? Constants.SearchbarIcons.magnifyingGlass.rawValue : Constants.SearchbarIcons.destination.rawValue)
                    TextField("Search by Name or Address", text: $destinationLabel)
                        .focused($focusedField, equals: .destination)
                }
                .modifier(InputFieldViewModifier(style: .alternate))
                .onTapGesture {
                    self.focusedField = .destination
                }
            }
            .padding(.horizontal, Constants.UI.horizontalSectionSpacing)
            .padding(.vertical, Constants.UI.verticalSectionSpacing)
            .background(Constants.Colors.mist)
            
            DirectionsMap(location: location)
            
            RouteTimeResultsView(distance: self.$distance)
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
