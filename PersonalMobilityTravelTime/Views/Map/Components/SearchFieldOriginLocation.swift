//
//  SearchFieldOriginLocation.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony van den Brandt on 12.12.2021.
//

import SwiftUI

struct SearchFieldOriginLocation: View {
    
    @EnvironmentObject var map: MapTabModel
    
    @FocusState.Binding var focusedField: MapViewContent.FocusField?
    
    var body: some View {
        // MARK: Search Field Origin Location
        if (self.map.state == .destinationSet) {
            HStack {
                Image(self.map.originPointState == .currentLocation ? Constants.SearchbarIcons.currentLocation.rawValue : Constants.SearchbarIcons.circle.rawValue)
                TextField("Search by Name or Address", text: self.$map.originLabel)
                    .focused($focusedField, equals: MapViewContent.FocusField.origin)
            }
            .modifier(InputFieldViewModifier(style: .alternate))
            .foregroundColor(self.map.originPointState == .currentLocation ? Color.secondary : Color.primary)
            .onTapGesture {
                self.focusedField = .origin
                // TODO: Remove "Current Location" text from the text field on tap, leaving the input field blank
//                if self.map.originLabel == "Current Location" {
//                    self.map.originLabel = ""
//                }
            }
        }
    }
}

//struct SearchFieldOriginLocation_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchFieldOriginLocation()
//    }
//}
