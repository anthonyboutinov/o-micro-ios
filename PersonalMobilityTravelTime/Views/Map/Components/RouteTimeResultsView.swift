//
//  RouteTimeResultsView.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony van den Brandt on 11.12.2021.
//

import SwiftUI

struct RouteTimeResultsView: View {
    
    @EnvironmentObject var model: ContentModel
    
    @Binding var distances: [MobilityDevice.TransportType: Double]
    @Binding var isExpanded: Bool
    
    /// First item in the sorted list is the selected device, then the rest go according to their speed, in decreasing order, while removing any electric devices that are unable to make such a journey, and display only the first few options so that the list at the bottom of the screen is not too big
    private func deviceList() -> ArraySlice<MobilityDevice> {
        let list = model.devices
            .sorted(by: { lhs, rhs in
                return lhs == model.selectedDevice ? true : (lhs.averageSpeedKmh > rhs.averageSpeedKmh && rhs != model.selectedDevice)
            })
            .filter { e in
                model.selectedDevice == e || !e.isElectric || (e.isElectric && MobilityDevice.Calculator.batteryUsage(distance: self.distances[e.transportType]!, capacity: e.distanceOnFullChargeKm!) <= Constants.CalculatorUI.batteryUsageDangerPercentage)
            }
        if isExpanded {
            return list.prefix(Int.max)
        } else {
            return list.prefix(Constants.CalculatorUI.maxOptionsForMapView)
        }
    }
    
    var body: some View {
        if self.distances.count == Set(self.model.devices.compactMap({ d in
            d.transportType
        })).count {
        HStack(alignment: .center, spacing: Constants.UI.itemSpacing / 2) {
            
            let devices = deviceList()
            
            VStack(alignment: .leading, spacing: Constants.UI.itemSpacing) {
                ForEach(devices) { device in
                    Text(device.title)
                        .fontWeight(model.selectedDevice == device ? .medium : .regular)
                        .foregroundColor(model.selectedDevice == device ? .black : .gray)
                }
            }
            
            Spacer()
            
            VStack(alignment: .leading, spacing: Constants.UI.itemSpacing) {
                ForEach(devices) { device in
                    
                    HStack(alignment: .center, spacing: 0) {
                        let travelTimeFormatted = MobilityDevice.Calculator.travelTimeFormattedCompactly(distance: self.distances[device.transportType]!, averageSpeedKmh: device.averageSpeedKmh, superCompact: device.isElectric)
                        
                        
                        let batteryUsage: Double? = device.isElectric && device.distanceOnFullChargeKm != nil ? MobilityDevice.Calculator.batteryUsage(distance: self.distances[device.transportType]!, capacity: device.distanceOnFullChargeKm!) : nil;
                        
                        // These have values if batteryUsage is not nil
                        let warningColor: Color? = warningColor(batteryUsage, device: device)
                        let batterySymbolPercentage: String = batteryImagePercentage(batteryUsage)
                        
                        if batteryUsage != nil && batteryUsage! > 2.0 {
                            // if it would be impossible to travel by this electric device, display custom info
                            Text("☠️")
                            batterySymbol(percentage: batterySymbolPercentage, color: warningColor!)
                        } else {
                        
                            Text("\(travelTimeFormatted)\(batteryUsage != nil ? " (" : "")")
                                .bold()
                                .foregroundColor(model.selectedDevice == device ? .black : .gray)
                                
                            if (batteryUsage != nil) {
                                Text("\(Int(batteryUsage! * 100))%")
                                    .bold()
                                    .foregroundColor(warningColor!)
                                batterySymbol(percentage: batterySymbolPercentage, color: warningColor!)
                                Text(")")
                                    .bold()
                                    .foregroundColor(model.selectedDevice == device ? .black : .gray)
                            }
                        }
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: Constants.UI.itemSpacing) {
                ForEach(devices) { device in
                    Text(String("\(self.distances[device.transportType]!.inCurrentUnits(model.units).removeZerosFromEnd(leaveFirst: 1)) \(model.units.description)"))
                        .bold()
                        .foregroundColor(model.selectedDevice == device ? .black : .gray)
                }
                .padding(.leading, 5.0)
            }
        }
        .lineLimit(1)
        .dynamicTypeSize(SwiftUI.DynamicTypeSize.xSmall)
        .allowsTightening(true)
        .padding(.horizontal, Constants.UI.horizontalSectionSpacing)
        .padding(.vertical, Constants.UI.verticalButtonSpacing)
        .onTapGesture {
            isExpanded.toggle()
        }
    }
    }
    
    private func batteryImagePercentage(_ batteryUsage: Double?) -> String {
        if let batteryUsage = batteryUsage {
            return batteryUsage < 0.125 ? "100" : (batteryUsage < 0.375 ? "75" : (batteryUsage < 0.625 ? "50" : (batteryUsage < 0.875 ? "25" : "0")))
        } else {
            return ""
        }
        
    }
    
    private func warningColor(_ batteryUsage: Double?, device: MobilityDevice) -> Color? {
        if let batteryUsage = batteryUsage {
            return batteryUsage >= Constants.CalculatorUI.batteryUsageWarningPercentage && batteryUsage < Constants.CalculatorUI.batteryUsageDangerPercentage ? Color.orange : (batteryUsage >= Constants.CalculatorUI.batteryUsageDangerPercentage ? Color.red : (model.selectedDevice == device ? Color.black : Color.gray))
        } else {
            return nil
        }
    }
    
    private func batterySymbol(percentage: String, color: Color) -> some View {
        Image(systemName: "battery.\(percentage)")
            .foregroundColor(color)
    }
}

struct RouteTimeResultsView_Previews: PreviewProvider {
//    @State static var xlong:  Double? = 400
//    @State static var long:   Double? = 24.23653
//    @State static var medium: Double? = 11.1
//    @State static var short:  Double? = 6
//    @State static var xshort: Double? = 0.914
    
    @State static var xlong: [MobilityDevice.TransportType: Double] = [
        MobilityDevice.TransportType.automobile: 400,
        MobilityDevice.TransportType.pedestrian: 399.8
    ]
    @State static var long: [MobilityDevice.TransportType: Double] = [
        MobilityDevice.TransportType.automobile: 24.23,
        MobilityDevice.TransportType.pedestrian: 22
    ]
    @State static var medium: [MobilityDevice.TransportType: Double] = [
        MobilityDevice.TransportType.automobile: 14,
        MobilityDevice.TransportType.pedestrian: 11.1
    ]
    @State static var short: [MobilityDevice.TransportType: Double] = [
        MobilityDevice.TransportType.automobile: 6,
        MobilityDevice.TransportType.pedestrian: 3.2
    ]
    @State static var xshort: [MobilityDevice.TransportType: Double] = [
        MobilityDevice.TransportType.automobile: 0.914,
        MobilityDevice.TransportType.pedestrian: 0.85
    ]
    
    @State static var expanded = true
    @State static var compact = false
    
    static var previews: some View {
        
        RouteTimeResultsView(distances: $long, isExpanded: $expanded)
            .previewLayout(.sizeThatFits)
            .environmentObject(ContentModel())
        
        RouteTimeResultsView(distances: $medium, isExpanded: $compact)
            .previewLayout(.sizeThatFits)
            .environmentObject(ContentModel())
        
        RouteTimeResultsView(distances: $short, isExpanded: $compact)
            .previewLayout(.sizeThatFits)
            .environmentObject(ContentModel())
        
        RouteTimeResultsView(distances: $xshort, isExpanded: $compact)
            .previewLayout(.sizeThatFits)
            .environmentObject(ContentModel())
        
        RouteTimeResultsView(distances: $xlong, isExpanded: $expanded)
            .previewLayout(.sizeThatFits)
            .environmentObject(ContentModel())
    }
}
