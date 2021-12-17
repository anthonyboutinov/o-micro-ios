//
//  CalculatorView.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 26.07.2021.
//

import SwiftUI

struct CalculatorView: View {
    
    @EnvironmentObject var model: ContentModel
    
    @State var distanceInCurrentUnits: Double = 0.0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                DeviceSelector()
                
                NavigationLink("Settings", destination: SettingsView())
                    .padding(.vertical, Constants.UI.verticalButtonSpacing)
            }
            .padding(.horizontal, Constants.UI.horizontalSectionSpacing)
            .padding(.top, Constants.UI.verticalSectionSpacing)
            
            if let selectedDevice = model.selectedDevice {
                CalculatorViewBody(calculator: CalculatorModel(averageSpeedKmh: selectedDevice.averageSpeedKmh, batteryRange: selectedDevice.rangeKm, distance: distanceInCurrentUnits.inKilometers(model.units)), distanceInCurrentUnits: $distanceInCurrentUnits)
            } else {
                Spacer()
            }
        }
    }
}

struct CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView()
            .environmentObject(ContentModel.preview())
    }
}
