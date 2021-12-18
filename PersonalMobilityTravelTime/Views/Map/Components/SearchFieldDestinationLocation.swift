//
//  SearchFieldDestinationLocation.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony van den Brandt on 12.12.2021.
//

import SwiftUI

struct SearchFieldDestinationLocation: View {
    
    @EnvironmentObject var map: MapTabModel
    
    @FocusState.Binding var focusedField: MapViewContent.FocusField?
    
    var body: some View {
        // MARK: Search Field Destination Location
        HStack {
            Image(self.map.state < .endLocationIsSet ? Constants.SearchbarIcons.magnifyingGlass.rawValue : Constants.SearchbarIcons.destination.rawValue)
                .renderingMode(.template)
                .foregroundColor(Color.primary)
            TextField("Search by Name or Address", text: self.$map.destinationLabel.didSet({ newValue in
                if self.map.state == .enteringEndLocation || self.map.state == .focusedOnEnteringEndLocation {
                    self.map.searchCompleter.queryFragment = newValue
                    self.map.state = .enteringEndLocation
                }
            }), onEditingChanged: { changed in
                if self.map.state == .enteringEndLocation {
                    self.map.searchCompleter.queryFragment = self.map.destinationLabel
                } else {
                    self.map.state = .enteringEndLocation
                }
            })
                .focused($focusedField, equals: MapViewContent.FocusField.destination)
                .disableAutocorrection(true)
        }
        .modifier(InputFieldViewModifier(style: .alternate))
        .onTapGesture {
            self.focusedField = .destination
            self.map.state = .focusedOnEnteringEndLocation
        }
    }
}

//struct SearchFieldDestinationLocation_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchFieldDestinationLocation()
//    }
//}
