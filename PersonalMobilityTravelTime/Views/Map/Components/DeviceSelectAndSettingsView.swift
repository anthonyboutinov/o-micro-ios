//
//  DeviceSelectAndSettingsView.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony van den Brandt on 11.12.2021.
//

import SwiftUI

struct DeviceSelectAndSettingsView: View {
    
    @EnvironmentObject var model: ContentModel
    
    @Binding var distance: Double?
    
    var body: some View {
        HStack {
            let batteryUsage: Double? = self.distance != nil ? (model.selectedDevice?.distanceOnFullChargeKm != nil && model.selectedDevice?.isElectric != nil ? MobilityDevice.Calculator.batteryUsage(distance: self.distance!, capacity: model.selectedDevice!.distanceOnFullChargeKm!) : nil) : nil
            DeviceSelector()
                .accentColor(batteryUsage != nil && batteryUsage! >= Constants.CalculatorUI.batteryUsageDangerPercentage ? Color.red : Color.accentColor)
            
            NavigationLink("Settings", destination: SettingsView())
                .padding(.vertical, Constants.UI.verticalButtonSpacing)
        }
    }
}

struct DeviceSelectAndSettingsView_Previews: PreviewProvider {
    @State static var d: Double? = 21.2
    static var previews: some View {
        DeviceSelectAndSettingsView(distance: $d)
            .previewLayout(.sizeThatFits)
            .environmentObject(ContentModel())
        
        DeviceSelectAndSettingsView(distance: $d)
            .previewLayout(.sizeThatFits)
            .environmentObject(ContentModel().selectDevice(atIndex: 1))
    }
}
