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
    
    @State var distance: Double = 19.3
    
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
                
                HStack {
                    let batteryUsage: Double? = model.selectedDevice?.distanceOnFullChargeKm != nil && model.selectedDevice?.isElectric != nil ? MobilityDevice.Calculator.batteryUsage(distance: self.distance, capacity: model.selectedDevice!.distanceOnFullChargeKm!) : nil
                    DeviceSelector()
                        .accentColor(batteryUsage != nil && batteryUsage! >= Constants.CalculatorUI.batteryUsageDangerPercentage ? Color.red : Color.accentColor)
                    
                    NavigationLink("Settings", destination: SettingsView())
                        .padding(.vertical, Constants.UI.verticalButtonSpacing)
                }
                
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
//                .ignoresSafeArea()
            
            HStack(alignment: .center, spacing: Constants.UI.itemSpacing / 2) {
                /// First item in the sorted list is the selected device, then the rest go according to their speed, in decreasing order, while removing any electric devices that are unable to make such a journey, and display only the first few options so that the list at the bottom of the screen is not too big
                let devicesWhereSelectedGoesFirst = model.devices
                    .sorted(by: { lhs, rhs in
                    return lhs == model.selectedDevice ? true : (lhs.averageSpeedKmh > rhs.averageSpeedKmh && rhs != model.selectedDevice)
                })
                    .filter { e in
                        model.selectedDevice == e || !e.isElectric || (e.isElectric && MobilityDevice.Calculator.batteryUsage(distance: self.distance, capacity: e.distanceOnFullChargeKm!) <= Constants.CalculatorUI.batteryUsageDangerPercentage)
                    }
                    .prefix(Constants.CalculatorUI.maxOptionsForMapView)
                
                VStack(alignment: .leading, spacing: Constants.UI.itemSpacing) {
                ForEach(devicesWhereSelectedGoesFirst) { device in
                    Text(device.title)
                        .fontWeight(model.selectedDevice == device ? .medium : .regular)
                        .foregroundColor(model.selectedDevice == device ? .black : .gray)
                        .multilineTextAlignment(.leading)
                        .dynamicTypeSize(SwiftUI.DynamicTypeSize.xSmall)
                        .lineLimit(1)
                        .allowsTightening(true)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: Constants.UI.itemSpacing) {
                    ForEach(devicesWhereSelectedGoesFirst) { device in
                    
                    HStack(alignment: .center, spacing: 0) {
                        let travelTimeFormatted = MobilityDevice.Calculator.travelTimeFormattedCompactly(distance: self.distance, averageSpeedKmh: device.averageSpeedKmh, superCompact: device.isElectric)
                        
                        Text("\(travelTimeFormatted)\(device.isElectric ? " (" : "")").bold().dynamicTypeSize(SwiftUI.DynamicTypeSize.xSmall)
                            .foregroundColor(model.selectedDevice == device ? .black : .gray)
                        if (device.isElectric && device.distanceOnFullChargeKm != nil) {
                            
                            let batteryUsage = MobilityDevice.Calculator.batteryUsage(distance: self.distance, capacity: device.distanceOnFullChargeKm!)
                            
                            let foregroundColor: Color = batteryUsage >= Constants.CalculatorUI.batteryUsageWarningPercentage && batteryUsage < Constants.CalculatorUI.batteryUsageDangerPercentage ? Color.orange : (batteryUsage >= Constants.CalculatorUI.batteryUsageDangerPercentage ? Color.red : (model.selectedDevice == device ? Color.black : Color.gray))
                            let batteryImagePercentage = batteryUsage < 0.125 ? "100" : (batteryUsage < 0.375 ? "75" : (batteryUsage < 0.625 ? "50" : (batteryUsage < 0.875 ? "75" : "100")))
                            
                            Text("\(Int(batteryUsage * 100))%")
                                .bold()
                                .foregroundColor(foregroundColor)
                                .dynamicTypeSize(SwiftUI.DynamicTypeSize.xSmall)
                            Image(systemName: "battery.\(batteryImagePercentage)")
                                .foregroundColor(foregroundColor)
                            Text(")")
                                .bold()
                                .dynamicTypeSize(SwiftUI.DynamicTypeSize.xSmall)
                                .foregroundColor(model.selectedDevice == device ? .black : .gray)
                            }
                        }
                    .lineLimit(1)
                    .allowsTightening(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: Constants.UI.itemSpacing) {
                ForEach(devicesWhereSelectedGoesFirst) { device in
                    Text(String(format: "%.1f \(model.units.description)", self.distance.inCurrentUnits(model.units)))
                            .bold()
                            .dynamicTypeSize(SwiftUI.DynamicTypeSize.xSmall)
                            .lineLimit(1)
                            .allowsTightening(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                            .foregroundColor(model.selectedDevice == device ? .black : .gray)
                    }
                }
            }
            .padding(.horizontal, Constants.UI.horizontalSectionSpacing)
            .padding(.vertical, Constants.UI.verticalButtonSpacing)
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
