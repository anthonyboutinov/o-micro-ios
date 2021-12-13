//
//  UnitOption.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony van den Brandt on 13.12.2021.
//

import SwiftUI

struct UnitOption: View {
    
    @EnvironmentObject var model: ContentModel
    
    var unit: ContentModel.Units
    
    var body: some View {
        Button {
            model.units = unit
        } label: {
            HStack(alignment: .center, spacing: 0) {
                Text(unit.fullDescription)
                    .foregroundColor(Constants.Colors.text)
                if model.units == unit {
                    Spacer()
                    Text("\(Image(systemName: "checkmark"))")
                }
            }
        }
    }
}
