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
        ScrollView {
            VStack(alignment: .leading, spacing: Constants.UI.sectionSpacing) {
//                Text("Units of Measure")
//                    .font(.largeTitle)
//                    .bold()
                
                HStack {
                    Text("Units")
                    Spacer()
                    Picker(selection: $model.units, label: Text("Picker"), content: {
                        Text(ContentModel.Units.imperial.fullDescription).tag(ContentModel.Units.imperial)
                        Text(ContentModel.Units.metric.fullDescription).tag(ContentModel.Units.metric)
                    })
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.vertical, -10)
                    .padding(.trailing, -12)
                }
                .modifier(InputFieldViewModifier())
            }
            .padding(.horizontal, Constants.UI.horizontalSectionSpacing)
            .padding(.vertical, Constants.UI.verticalSectionSpacing)
        }
        .navigationTitle("Units of Measure")
    }
}

struct UnitsOfMeasureView_Previews: PreviewProvider {
    static var previews: some View {
        UnitsOfMeasureView()
            .environmentObject(ContentModel())
    }
}
