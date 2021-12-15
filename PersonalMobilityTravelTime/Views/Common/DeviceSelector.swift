//
//  DeviceSelector.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 28.07.2021.
//

import SwiftUI

struct DeviceSelector: View {
    
    @EnvironmentObject var model: ContentModel
    
    var accentColor: Color = .accentColor
    
    private static let scaleFactor = DeviceIcon.scaleFactor(.medium)
    
    var body: some View {
        ScrollView(Axis.Set.horizontal, showsIndicators: false) {
            HStack(alignment: .bottom, spacing: Constants.UI.deviceSelectorItemSpacing) {
                ForEach(model.devices) { device in
                    Button(action: {
                        model.selectedDevice = device
                    }) {
                        VStack(alignment: .leading, spacing: 1) {
                            LinearGradient(gradient: self.gradient(model.selectedDevice == device), startPoint: .top, endPoint: .bottom)
                                .mask(DeviceIcon(named: device.iconName))
                                .frame(width: Constants.UI.deviceIconSize * DeviceSelector.scaleFactor, height: Constants.UI.deviceIconSize * DeviceSelector.scaleFactor, alignment: .center)
                            
                            Text(device.title)
                                .font(.caption2)
                        }
                    }
                    .foregroundColor(model.selectedDevice == device ? self.accentColor : Color.primary)
                }
            }
        }
    }
    
    private func gradient(_ useGradient: Bool) -> Gradient {
        if useGradient {
            return (accentColor == .red || accentColor == Constants.Colors.red) ? Constants.Colors.redGradient : Constants.Colors.primaryGradient
        } else {
            return Gradient(colors: [Color.primary, Color.primary])
        }
    }
}

struct DeviceSelector_Previews: PreviewProvider {
    static var previews: some View {
        DeviceSelector()
            .previewLayout(.sizeThatFits)
            .environmentObject(ContentModel.preview())
    }
}
