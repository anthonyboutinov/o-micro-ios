//
//  InputFieldViewModifier.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 26.07.2021.
//

import SwiftUI

struct InputFieldViewModifier: ViewModifier {
    
    var style: Style = .normal
    
    func body(content: Content) -> some View {
        content
            .font(Font.system(size: 14))
            .padding(.horizontal, Constants.UI.horizontalButtonSpacing)
            .padding(.vertical, Constants.UI.verticalButtonSpacing)
            .background(style == .normal ? Constants.Colors.quartz : Color.white)
            .foregroundColor(.black)
            .cornerRadius(Constants.UI.cornerRadius)
            .frame(maxWidth: .infinity)
    }
    
    enum Style {
        case normal
        case alternate
    }
}
