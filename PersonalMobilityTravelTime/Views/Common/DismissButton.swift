//
//  DismissButton.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony van den Brandt on 14.12.2021.
//

import SwiftUI

struct DismissButton: View {
    
    var text: LocalizedStringKey
    
    var action: Optional<() -> ()>
    
    var backgroundColor: Color
    
    var disabled: Bool
    
    enum Style {
        case primary
        case destructive // TODO: I only ever use primary with this view
    }
    
    init(text: LocalizedStringKey = "Done", backgroundColor: Color = Color.accentColor, disabled: Bool = false, action: Optional<() -> ()> = nil) {
        self.text = text
        self.backgroundColor = backgroundColor
        self.action = action
        self.disabled = disabled
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
        .listRowBackground(disabled ? Constants.Colors.transparent : backgroundColor)
        .foregroundColor(disabled ? Color.secondary : Color.white)
        .disabled(disabled)
    }
}

struct DismissButton_Previews: PreviewProvider {
    static var previews: some View {
        DismissButton()
    }
}
