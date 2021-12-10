//
//  RouteTimeResultsView.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony van den Brandt on 11.12.2021.
//

import SwiftUI

struct RouteTimeResultsView: View {
    
    @EnvironmentObject var model: ContentModel
    
    @Binding var distance: Double?
    
    var body: some View {
        if self.distance != nil {
        HStack(alignment: .center, spacing: Constants.UI.itemSpacing / 2) {
            /// First item in the sorted list is the selected device, then the rest go according to their speed, in decreasing order, while removing any electric devices that are unable to make such a journey, and display only the first few options so that the list at the bottom of the screen is not too big
            let devicesWhereSelectedGoesFirst = model.devices
                .sorted(by: { lhs, rhs in
                    return lhs == model.selectedDevice ? true : (lhs.averageSpeedKmh > rhs.averageSpeedKmh && rhs != model.selectedDevice)
                })
                .filter { e in
                    model.selectedDevice == e || !e.isElectric || (e.isElectric && MobilityDevice.Calculator.batteryUsage(distance: self.distance!, capacity: e.distanceOnFullChargeKm!) <= Constants.CalculatorUI.batteryUsageDangerPercentage)
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
                        let travelTimeFormatted = MobilityDevice.Calculator.travelTimeFormattedCompactly(distance: self.distance!, averageSpeedKmh: device.averageSpeedKmh, superCompact: device.isElectric)
                        
                        Text("\(travelTimeFormatted)\(device.isElectric ? " (" : "")").bold().dynamicTypeSize(SwiftUI.DynamicTypeSize.xSmall)
                            .foregroundColor(model.selectedDevice == device ? .black : .gray)
                        if (device.isElectric && device.distanceOnFullChargeKm != nil) {
                            
                            let batteryUsage = MobilityDevice.Calculator.batteryUsage(distance: self.distance!, capacity: device.distanceOnFullChargeKm!)
                            
                            let foregroundColor: Color = batteryUsage >= Constants.CalculatorUI.batteryUsageWarningPercentage && batteryUsage < Constants.CalculatorUI.batteryUsageDangerPercentage ? Color.orange : (batteryUsage >= Constants.CalculatorUI.batteryUsageDangerPercentage ? Color.red : (model.selectedDevice == device ? Color.black : Color.gray))
                            let batteryImagePercentage = batteryUsage < 0.125 ? "100" : (batteryUsage < 0.375 ? "75" : (batteryUsage < 0.625 ? "50" : (batteryUsage < 0.875 ? "25" : "0")))
                            
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
                    .allowsTightening(true)
                }
            }
            
//            Spacer()
            
            VStack(alignment: .leading, spacing: Constants.UI.itemSpacing) {
                ForEach(devicesWhereSelectedGoesFirst) { device in
                    Text(String(format: "%.1f \(model.units.description)", self.distance!.inCurrentUnits(model.units)))
                        .bold()
                        .dynamicTypeSize(SwiftUI.DynamicTypeSize.xSmall)
                        .lineLimit(1)
                        .allowsTightening(true)
                        .foregroundColor(model.selectedDevice == device ? .black : .gray)
                }
                .padding(.leading, 5.0)
            }
        }
        .padding(.horizontal, Constants.UI.horizontalSectionSpacing)
        .padding(.vertical, Constants.UI.verticalButtonSpacing)
    }
    }
}

struct RouteTimeResultsView_Previews: PreviewProvider {
    @State static var long:   Double? = 21.23653
    @State static var medium: Double? = 11.1
    @State static var short:  Double? = 6
    @State static var xshort:  Double? = 0.914
    
    static var previews: some View {
        
        RouteTimeResultsView(distance: $long)
            .previewLayout(.sizeThatFits)
            .environmentObject(ContentModel())
        
        RouteTimeResultsView(distance: $medium)
            .previewLayout(.sizeThatFits)
            .environmentObject(ContentModel())
        
        RouteTimeResultsView(distance: $short)
            .previewLayout(.sizeThatFits)
            .environmentObject(ContentModel())
        
        RouteTimeResultsView(distance: $xshort)
            .previewLayout(.sizeThatFits)
            .environmentObject(ContentModel())
    }
}
