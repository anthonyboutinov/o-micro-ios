//
//  UnitOption.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony van den Brandt on 13.12.2021.
//

import SwiftUI

struct UnitOption: View {
    
    @EnvironmentObject var model: ContentModel
    
    var unit: Units
    
    var body: some View {
        Button {
            model.units = unit
        } label: {
            HStack(alignment: .center, spacing: 0) {
                Text(unit.optionTitle)
                    .foregroundColor(Color.primary)
                if model.units == unit {
                    Spacer()
                    Text("\(Image(systemName: "checkmark"))")
                }
            }
        }
    }
}
