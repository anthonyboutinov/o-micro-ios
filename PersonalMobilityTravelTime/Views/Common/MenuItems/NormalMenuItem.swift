//
//  NormalMenuItem.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 26.07.2021.
//

import SwiftUI

struct NormalMenuItem: View {
    var icon: String?
    var label: String
    var currentValue: String?
    
    var body: some View {
        HStack(spacing: Constants.UI.horizontalButtonSpacing) {
            if let icon = icon {
                Image(systemName: icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: Constants.UI.deviceIconSize, height: Constants.UI.deviceIconSize, alignment: .center)
            }
            Text(label)
                .multilineTextAlignment(.leading)
            
            if let currentValue = currentValue {
                Spacer()
                Text(currentValue)
                    .foregroundColor(Color.secondary)
            }
        }
    }
}

struct DeviceMenuItemView_Previews: PreviewProvider {
    static var previews: some View {
        NormalMenuItem(icon: "checkmark.shield", label: "Privacy Policy")
            .previewLayout(.sizeThatFits)
    }
}
