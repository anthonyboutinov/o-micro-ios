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
    
    var backgroundColor: Color
    
    enum Style {
        case primary
        case destructive // TODO: I only ever use primary with this view
    }
    
    init(text: String = Constants.Text.done, backgroundColor: Color = Color.accentColor, action: Optional<() -> ()> = nil) {
        self.text = text
        self.backgroundColor = backgroundColor
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
        .listRowBackground(backgroundColor)
        .foregroundColor(Color.white)
    }
}

struct DismissButton_Previews: PreviewProvider {
    static var previews: some View {
        DismissButton()
    }
}
