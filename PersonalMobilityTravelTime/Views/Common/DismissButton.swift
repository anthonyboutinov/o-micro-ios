//
//  DismissButton.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony van den Brandt on 14.12.2021.
//

import SwiftUI

struct DismissButton: View {
    
    var text: String
    
    var action: Optional<() -> ()>
    
    var style: Style
    
    enum Style {
        case primary
        case destructive // TODO: I only ever use primary with this view
    }
    
    init(text: String = "Done", style: Style = .primary, action: Optional<() -> ()> = nil) {
        self.text = text
        self.style = style
        self.action = action
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Button {
            action?()
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text(text)
                .frame(maxWidth: .infinity)
        }
        .listRowBackground(background)
        .foregroundColor(Constants.Colors.textInverse)
    }
    
    private var background: Color {
        switch style {
        case .primary: return Color.accentColor
        case .destructive: return Constants.Colors.red
        }
    }
}

struct DismissButton_Previews: PreviewProvider {
    static var previews: some View {
        DismissButton()
    }
}
