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
    
    @State var distance: Double? = nil
    
    // MARK: UI
    
    @State var destinationLabel: String = ""
    @State var originLabel: String = Constants.Text.currentLocationLabel
        
    enum ViewState: Hashable {
        case initial
        case focusedOnEnteringDestination
        case enteringDestination
        case destinationSet
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
    
    // MARK: Suggestions
    
    @StateObject var searchCompleterDelegate = SearchCompleterDelegate()
    var searchCompleter = MKLocalSearchCompleter()
    var searchRegion = MKCoordinateRegion(MKMapRect.world)
    var currentPlacemark: CLPlacemark?
    
    // MARK: - body
        
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: Constants.UI.itemSpacing) {
                
                DeviceSelectAndSettingsView(distance: self.$distance)
                
                // MARK: Search Field Origin Location
                if (self.state == .destinationSet) {
                    HStack {
                        Image(self.originPointState == .currentLocation ? Constants.SearchbarIcons.currentLocation.rawValue : Constants.SearchbarIcons.circle.rawValue)
                        TextField(Constants.Text.searchPlaceholder, text: $originLabel)
                            .focused($focusedField, equals: .origin)
                    }
                    .modifier(InputFieldViewModifier(style: .alternate))
                    .foregroundColor(self.originPointState == .currentLocation ? .gray : .black)
                    .onTapGesture {
                        self.focusedField = .origin
                    }
                }
                
                // MARK: Search Field Destination Location
                HStack {
                    Image(self.state != .destinationSet ? Constants.SearchbarIcons.magnifyingGlass.rawValue : Constants.SearchbarIcons.destination.rawValue)
                    TextField(Constants.Text.searchPlaceholder, text: $destinationLabel.didSet({ newValue in
                        self.searchCompleter.queryFragment = newValue
                        self.state = .enteringDestination
                    }), onEditingChanged: { changed in
                        self.searchCompleter.queryFragment = self.destinationLabel
                    })
                        .focused($focusedField, equals: .destination)
                }
                .modifier(InputFieldViewModifier(style: .alternate))
                .onTapGesture {
                    self.focusedField = .destination
                    self.state = .focusedOnEnteringDestination
                }
                
                if searchCompleterDelegate.completerResults.count != 0 {
                    CompleterResults(completerResults: self.$searchCompleterDelegate.completerResults)
                }
            }
            .padding(.horizontal, Constants.UI.horizontalSectionSpacing)
            .padding(.vertical, Constants.UI.verticalSectionSpacing)
            .background(Constants.Colors.mist)
            
            if self.state == .initial || self.state == .destinationSet {
                DirectionsMap(location: location)
                    .frame(maxHeight: .infinity)
            } else {
                Spacer()
            }
            
            RouteTimeResultsView(distance: self.$distance)
        }
        .navigationBarTitle("") //this must be empty
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            self.startProvidingCompletions()
        }
    }
    
    private func startProvidingCompletions() {
        searchCompleter.delegate = self.searchCompleterDelegate
        searchCompleter.resultTypes = [.address, .pointOfInterest]
        searchCompleter.region = searchRegion
    }
    
    mutating func updatePlacemark(_ placemark: CLPlacemark?, boundingRegion: MKCoordinateRegion) {
        currentPlacemark = placemark
        searchCompleter.region = searchRegion
    }
}

struct MapViewContent_Previews: PreviewProvider {
    static var previews: some View {
        MapViewContent()
            .environmentObject(ContentModel())
    }
}
