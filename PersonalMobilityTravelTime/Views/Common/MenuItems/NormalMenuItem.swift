//
//  NormalMenuItem.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 26.07.2021.
//

import SwiftUI

struct NormalMenuItem: View {
    var icon: String
    var label: String
    
    var body: some View {
        HStack(spacing: Constants.UI.horizontalButtonSpacing) {
            Image(systemName: icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: Constants.UI.deviceIconSize, height: Constants.UI.deviceIconSize, alignment: .center)
            Text(label)
                .fontWeight(.medium)
                .multilineTextAlignment(.leading)
            Spacer()
            Image(systemName: "chevron.right")
        }
    }
}

struct DeviceMenuItemView_Previews: PreviewProvider {
    static var previews: some View {
        NormalMenuItem(icon: "checkmark.shield", label: "Privacy Policy")
            .previewLayout(.sizeThatFits)
    }
}
