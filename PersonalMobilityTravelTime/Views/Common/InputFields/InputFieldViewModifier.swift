//
//  InputFieldViewModifier.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 26.07.2021.
//

import SwiftUI

struct InputFieldViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.system(size: 14))
            .padding(.horizontal, Constants.UI.horizontalButtonSpacing)
            .padding(.vertical, Constants.UI.verticalButtonSpacing)
            .background(Constants.Colors.quartz)
            .foregroundColor(.black)
            .cornerRadius(Constants.UI.cornerRadius)
            .frame(maxWidth: .infinity)
    }
}
