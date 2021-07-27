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
            .modifier(InputFieldViewModifier())
    }
}
