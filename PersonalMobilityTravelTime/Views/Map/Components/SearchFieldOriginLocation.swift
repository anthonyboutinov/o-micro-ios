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
        if (self.map.state >= .endLocationIsSet) {
            HStack {
                Image(iconName())
                    .renderingMode(.template)
                    .foregroundColor(Color.primary)
                TextField("Search by Name or Address", text: self.$map.originLabel.didSet({ newValue in
                    if self.map.state == .enteringStartLocation || self.map.state == .focusedOnEnteringStartLocation {
                        self.map.searchCompleter.queryFragment = newValue
                        self.map.state = .enteringStartLocation
                    }
                }), onEditingChanged: { changed in
                    if self.map.state == .enteringStartLocation {
                        self.map.searchCompleter.queryFragment = self.map.originLabel
                    } else {
                        self.map.state = .enteringStartLocation
                    }
                })
                    .focused($focusedField, equals: MapViewContent.FocusField.origin)
                    .disableAutocorrection(true)
            }
            .modifier(InputFieldViewModifier(style: .alternate))
            .foregroundColor(self.map.originPointState == .currentLocation ? Color.secondary : Color.primary)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(self.map.originLabel != "" ? LocalizedStringKey("Origin set to: \(self.map.originLabel)") : LocalizedStringKey("Origin search text field. Search by name or address"))
            .accessibilityHint("Double tap to edit")
            .onTapGesture {
                // Remove "Current Location" text from the text field on tap, leaving the input field blank
                if self.map.originLabel == String(localized: "Current Location") {
                    self.map.originLabel = ""
                }
                self.focusedField = .origin
                self.map.state = .focusedOnEnteringStartLocation
            }
        }
    }
    
    func iconName() -> String {
        var icon: Constants.SearchbarIcons?
        if self.map.state >= .focusedOnEnteringStartLocation && self.map.state < .startLocationIsSet {
            icon = .magnifyingGlass
        } else if self.map.originPointState == .currentLocation {
            icon = .currentLocation
        } else {
            icon = .circle
        }
        return icon!.rawValue
    }
}

//struct SearchFieldOriginLocation_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchFieldOriginLocation()
//    }
//}
