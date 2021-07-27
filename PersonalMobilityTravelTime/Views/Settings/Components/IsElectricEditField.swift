//
//  IsElectricEditField.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 27.07.2021.
//

import SwiftUI
//import PartialSheet

struct IsElectricEditField: View {
//    @EnvironmentObject var partialSheetManager: PartialSheetManager
    
    @Binding var isElectric: Bool
    
    var body: some View {
        
//        Button(action: {
//            self.partialSheetManager.showPartialSheet({}) {
//                SelectorView(selectedValue: $isElectric)
//            }
//        }) {
//            HStack {
//                Text("Vehicle Kind")
//                Spacer()
//                Text(isElectric ? "Electric" : "Non-Electric")
//                    .multilineTextAlignment(.trailing)
//                    .font(Font.system(size: 14, weight: .semibold))
//            }
//            .modifier(InputFieldViewModifier())
//        }
        
        HStack {
            Text("Kind")
            Spacer()
            Picker(selection: $isElectric, label: Text("Picker"), content: {
                Text("Electric").tag(true)
                Text("Non-Electric").tag(false)
            })
            .pickerStyle(SegmentedPickerStyle())
            .padding(.vertical, -10)
            .padding(.trailing, -12)
            //                Text(isElectric ? "Electric" : "Non-Electric")
            //                    .multilineTextAlignment(.trailing)
            //                    .font(Font.system(size: 14, weight: .semibold))
        }
        .modifier(InputFieldViewModifier())
        
    }
}
