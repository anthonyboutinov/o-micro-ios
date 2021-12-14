//
//  IconEditField.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 27.07.2021.
//

import SwiftUI

struct IconEditField: View {
    
    @ObservedObject var device: MobilityDevice
    
    var body: some View {
        NavigationLink {
            ChooseIconView(selectedIcon: $device.iconName)
        } label: {
            HStack {
                Text("Icon")
                Spacer()
                if device.iconName != "" {
                    DeviceIcon(named: device.iconName)
//                        .padding(.vertical, Constants.UI.deviceIconVerticalPaddingInButtons)
                }
            }
        }
    }
}
