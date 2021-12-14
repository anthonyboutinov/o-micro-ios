//
//  IconEditField.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 27.07.2021.
//

import SwiftUI

struct IconEditField: View {
    
    
    @ObservedObject var device: MobilityDevice
    
//    @Binding var iconName: String
//
//    @State private var tempValue: String = ""
//    @State private var changeApproved = true // approve by default unless the user clicks Cancel
    
    var body: some View {
        
        NavigationLink {
            ChooseIconView(selectedIcon: $device.iconName)
        } label: {
            HStack {
                Text("Icon")
                Spacer()
                if device.iconName != "" {
                    DeviceIcon(named: device.iconName)
//                        .padding(.vertical, Constants.UI.deviceIconVerticalPaddingInButtons)
                }
            }
        }

//        Button(action: {
//            UIApplication.shared.endEditing()
//            self.isSheetShown = true
//        }) {
//            HStack {
//                Text("Icon")
//                Spacer()
//                if iconName != "" {
//                    DeviceIcon(named: iconName)
//                        .padding(.vertical, Constants.UI.deviceIconVerticalPaddingInButtons)
//                }
//            }
//        }
//        .foregroundColor(Color.primary)
//        .partialSheet(isPresented: $isSheetShown) {
//            ChooseIconView(selectedIcon: self.$tempValue, changeApproved: $changeApproved, isSheetShown: $isSheetShown)
//        }
//        .onChange(of: self.isSheetShown, perform: { value in
//            if value == false {
//                if changeApproved == true && tempValue != "" {
//                    iconName = tempValue
//                } else {
//                    changeApproved = true // reset changeApproved
//                    tempValue = iconName // reset tempValue
//                }
//            }
//        })
        
    }
}
