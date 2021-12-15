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
    @Binding var state: MapTabModel.ViewState
    
    @FocusState.Binding var focusedField: MapViewContent.FocusField?
    
    var body: some View {
        HStack {
            let batteryUsage: Double? = self.distance != nil ? (model.selectedDevice?.rangeKm != nil && model.selectedDevice?.isElectric != nil ? MobilityDevice.Calculator.batteryUsage(distance: self.distance!, capacity: model.selectedDevice!.rangeKm!) : nil) : nil
            DeviceSelector(accentColor: batteryUsage != nil && batteryUsage! >= Constants.CalculatorUI.batteryUsageDangerPercentage ? Constants.Colors.red : Color.accentColor)
            
            if state == .initial {
                NavigationLink("Settings", destination: SettingsView())
                    .padding(.vertical, Constants.UI.verticalButtonSpacing)
            } else {
                Text("Cancel")
                    .padding(.vertical, Constants.UI.verticalButtonSpacing)
                    .onTapGesture {
                        state = .initial
                        focusedField = nil
                    }
            }
        }
    }
}

struct DeviceSelectAndSettingsView_Previews: PreviewProvider {
    @State static var d: Double? = 21.2
    @State static var stateA: MapTabModel.ViewState = .destinationSet
    @State static var stateB: MapTabModel.ViewState = .initial
    @FocusState static var focusedField: MapViewContent.FocusField?
    static var previews: some View {
        DeviceSelectAndSettingsView(distance: $d, state: $stateA, focusedField: $focusedField)
            .previewLayout(.sizeThatFits)
            .environmentObject(ContentModel.preview())
        
        DeviceSelectAndSettingsView(distance: $d, state: $stateB, focusedField: $focusedField)
            .previewLayout(.sizeThatFits)
            .environmentObject(ContentModel.preview().selectDevice(atIndex: 1))
    }
}
