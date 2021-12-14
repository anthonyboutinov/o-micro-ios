//
//  UnitsOfMeasureView.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony van den Brandt on 10.12.2021.
//

import SwiftUI

struct UnitsOfMeasureView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        List {
            ForEach(ContentModel.Units.all) {unit in
                UnitOption(unit: unit)
            }
        }
        .navigationTitle("Distance units")
    }
}

struct UnitsOfMeasureView_Previews: PreviewProvider {
    static var previews: some View {
        UnitsOfMeasureView()
            .environmentObject(ContentModel())
    }
}
