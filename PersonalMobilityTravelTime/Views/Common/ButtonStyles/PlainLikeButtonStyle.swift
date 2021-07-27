//
//  PlainButtonStyle.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 26.07.2021.
//

import SwiftUI

struct PlainLikeButtonStyle: ButtonStyle {
    var style = Styles.white
    
    private func foregroundColor() -> Color {
        switch style {
        case .primary:
            return Color.white
        case .destructive:
            return Color.red
        case .cancel:
            return Constants.Colors.graphite
        default:
            return Color.accentColor
        }
    }
    
    private func backgroundColor() -> Color {
        switch style {
        case .primary:
            return Color.accentColor
        default:
            return Color.white
        }
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
//            .font(Font.system(size: 14))
            .font(.body)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, Constants.UI.horizontalButtonSpacing)
            .padding(.vertical, Constants.UI.verticalButtonSpacing)
            .foregroundColor(foregroundColor())
            .background(backgroundColor())
            .cornerRadius(Constants.UI.cornerRadius)
    }
    
    init(_ style: Styles = Styles.white) {
        self.style = style
    }
    
    enum Styles {
        case white
        case primary
        case destructive
        case cancel
    }
}
