//
//  DeviceMenuItemView.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 26.07.2021.
//

import SwiftUI

struct DeviceMenuItem: View {
    var imageName: String
    var label: String
    
    var body: some View {
        HStack(spacing: Constants.UI.horizontalButtonSpacing) {
            LinearGradient(gradient: Constants.Colors.primaryGradient, startPoint: .top, endPoint: .bottom)
                .mask(Image(imageName)
//                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit))
                .frame(width: Constants.UI.deviceIconSize, height: Constants.UI.deviceIconSize, alignment: .center)
//                        .foregroundColor(Color.primary))
            
            Text(label)
                .multilineTextAlignment(.leading)
        }
    }
}

struct DeviceMenuItem_Previews: PreviewProvider {
    static var previews: some View {
        DeviceMenuItem(imageName: "022-electricscooter", label: "Ninebot ES1")
            .previewLayout(.sizeThatFits)
    }
}
