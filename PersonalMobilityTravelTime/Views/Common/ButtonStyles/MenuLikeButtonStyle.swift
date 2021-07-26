//
//  CommonButtonStyle.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 26.07.2021.
//

import SwiftUI

struct MenuLikeButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, Constants.UI.horizontalButtonSpacing)
            .padding(.vertical, Constants.UI.verticalButtonSpacing)
            .background(Constants.Colors.quartz)
            .cornerRadius(Constants.UI.cornerRadius)
    }
}
