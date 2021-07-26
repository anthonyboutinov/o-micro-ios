//
//  CenteredMenuItem.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 26.07.2021.
//

import SwiftUI

struct CenteredMenuItem: View {
    var icon: String
    var label: String
    
    var body: some View {
        HStack(spacing: Constants.UI.horizontalButtonSpacing) {
            Spacer()
            Text("\(Image(systemName: icon)) \(label)")
                .fontWeight(.medium)
                .multilineTextAlignment(.leading)
            Spacer()
        }
    }
}

struct CenteredMenuItem_Previews: PreviewProvider {
    static var previews: some View {
        CenteredMenuItem(icon: "plus.circle", label: "Add New")
    }
}
