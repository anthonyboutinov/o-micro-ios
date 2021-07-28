//
//  AverageSpeedEditField.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 27.07.2021.
//

import SwiftUI
import PartialSheet

struct AverageSpeedEditField: View {
    
    @EnvironmentObject var partialSheetManager: PartialSheetManager
    
    @ObservedObject var device: MobilityDevice
    
    @State private var tempValue = (distance: 0.0, time: 0.0, speed: 0.0)
    @State private var changeApproved = true // approve by default unless the user clicks Cancel
    @State var isSheetShown = false
    
    var body: some View {
        
        
        Button(action: {
            self.isSheetShown = true
        }) {
            HStack {
                Text("Average Speed")
                
                Spacer()
                
                Text(String(format: "%.2f", device.averageSpeedKmh))
                    .multilineTextAlignment(.trailing)
                    .font(Font.system(size: 14, weight: .semibold))
                
                Text("km/h")
                    .foregroundColor(Constants.Colors.graphite)
                    .fontWeight(.regular)
                    .frame(minWidth: 34, alignment: .trailing)
            }
            .modifier(InputFieldViewModifier())
        }
        .partialSheet(isPresented: $isSheetShown) {
            AverageSpeedCalculatorView(distance: $tempValue.distance, time: $tempValue.time, speed: $tempValue.speed, changeApproved: $changeApproved, isSheetShown: $isSheetShown)
        }
        .onChange(of: self.isSheetShown, perform: { value in
            if value == false {
                if changeApproved == true {
                    device.averageSpeedKmh = tempValue.speed
                    device.averageSpeedCalculatorData = MobilityDevice.AverageSpeedCalculatorData(distanceKm: tempValue.distance, travelTimeMinutes: tempValue.time)
                } else {
                    changeApproved = true // reset changeApproved
                    resetTempValue()
                }
            }
        })
        .onAppear(perform: {
            resetTempValue()
        })
    }
    
    private func resetTempValue() {
        self.tempValue = (distance: device.averageSpeedCalculatorData?.distanceKm ?? 0.0, time: device.averageSpeedCalculatorData?.travelTimeMinutes ?? 0.0, speed: device.averageSpeedKmh)
    }
}

struct AverageSpeedEditField_Previews: PreviewProvider {
    @StateObject static var d = MobilityDevice(index: 0)
    static var previews: some View {
        AverageSpeedEditField(device: d)
    }
}
