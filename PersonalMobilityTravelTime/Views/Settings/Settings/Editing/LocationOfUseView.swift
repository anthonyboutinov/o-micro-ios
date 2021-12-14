//
//  LocationOfUseView.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony van den Brandt on 14.12.2021.
//

import SwiftUI

struct LocationOfUseView: View {
    
    @EnvironmentObject var model: ContentModel
    
    @ObservedObject var device: MobilityDevice
    
    var body: some View {
        List {
            ForEach(MobilityDevice.TransportType.all) {type in
                TransportTypeOption(transportType: type, currentValue: $device.transportType)
            }
        }
        .navigationTitle("Location of Use")
    }
}

struct LocationOfUseView_Previews: PreviewProvider {
    static var previews: some View {
        UnitsOfMeasureView()
            .environmentObject(ContentModel())
    }
}
