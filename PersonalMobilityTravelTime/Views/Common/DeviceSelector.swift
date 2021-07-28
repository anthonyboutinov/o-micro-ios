//
//  DeviceSelector.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 28.07.2021.
//

import SwiftUI

struct DeviceSelector: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        ScrollView(Axis.Set.horizontal, showsIndicators: false) {
            HStack(alignment: .bottom, spacing: 15) {
                ForEach(model.devices) { device in
                    Button(action: {
                        model.selectedDevice = device
                    }) {
                        VStack(alignment: .leading, spacing: 1) {
                            DeviceIcon(named: device.iconName)
                            Text(device.title)
                                .font(.caption2)
                        }
                    }
                    .foregroundColor(model.isSelectedDevice(id: device.id) ? .accentColor : .black)
                }
            }
        }
    }
}

struct DeviceSelector_Previews: PreviewProvider {
    static var previews: some View {
        DeviceSelector()
            .previewLayout(.sizeThatFits)
            .environmentObject(ContentModel())
    }
}
