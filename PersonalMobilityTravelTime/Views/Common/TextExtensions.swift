//
//  SheetTitle.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 27.07.2021.
//

import SwiftUI

// You cannot add text modifiers inside a ViewModifier, so there's this
extension Text {
    func modifierSheetTitle() -> some View {
        self
            .font(.title2)
            .fontWeight(.bold)
            .padding(.top, 30)
//            .padding(.bottom, 30)
            
    }
    
    func modifierBodyText() -> some View {
        self
            .font(.caption)
//            .font(Font.system(size: 14, weight: .regular))
            .foregroundColor(Color.secondary)
            .lineLimit(nil)
            .multilineTextAlignment(.leading)
            .fixedSize(horizontal: false, vertical: true)
    }
}
