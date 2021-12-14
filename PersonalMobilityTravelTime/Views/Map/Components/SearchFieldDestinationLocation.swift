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
            Image(self.map.state != .destinationSet ? Constants.SearchbarIcons.magnifyingGlass.rawValue : Constants.SearchbarIcons.destination.rawValue)
                .renderingMode(.template)
                .foregroundColor(Color.primary)
            TextField(Constants.Text.searchPlaceholder, text: self.$map.destinationLabel.didSet({ newValue in
                if self.map.state == .enteringDestination || self.map.state == .focusedOnEnteringDestination {
                    self.map.searchCompleter.queryFragment = newValue
                    self.map.state = .enteringDestination
                }
            }), onEditingChanged: { changed in
                if self.map.state == .enteringDestination {
                    self.map.searchCompleter.queryFragment = self.map.destinationLabel
                } else {
                    self.map.state = .enteringDestination
                }
            })
                .focused($focusedField, equals: MapViewContent.FocusField.destination)
        }
        .modifier(InputFieldViewModifier(style: .alternate))
        .onTapGesture {
            self.focusedField = .destination
            self.map.state = .focusedOnEnteringDestination
        }
    }
}

//struct SearchFieldDestinationLocation_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchFieldDestinationLocation()
//    }
//}
