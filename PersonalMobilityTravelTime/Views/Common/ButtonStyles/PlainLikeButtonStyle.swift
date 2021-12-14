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
            return Constants.Colors.red
        case .cancel:
            return Color.secondary
        default:
            return Color.accentColor
        }
    }
    
    private func backgroundColor() -> Color {
        switch style {
        case .primary:
            return Color.accentColor
        default:
            return Constants.Colors.transparent
        }
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
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

struct PlainLikeButtonStyle_Preview: PreviewProvider {
    static var previews: some View {
        
        VStack {
            
            Button {
                // nothing
            } label: {
                Text("Primary")
            }
            .buttonStyle(PlainLikeButtonStyle(.primary))
            
            Button {
                // nothing
            } label: {
                Text("White")
            }
            .buttonStyle(PlainLikeButtonStyle(.white))
            
            Button {
                // nothing
            } label: {
                Text("Cancel")
            }
            .buttonStyle(PlainLikeButtonStyle(.cancel))
            
            Button {
                // nothing
            } label: {
                Text("Destructive")
            }
            .buttonStyle(PlainLikeButtonStyle(.destructive))
            
        }
        
    }
}
