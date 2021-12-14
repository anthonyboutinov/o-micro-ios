//
//  TransportTypeOption.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony van den Brandt on 14.12.2021.
//

import SwiftUI

struct TransportTypeOption: View {
    
    var transportType: MobilityDevice.TransportType
    
    @Binding var currentValue: MobilityDevice.TransportType
    
    var body: some View {
        Button {
            currentValue = transportType
        } label: {
            HStack(alignment: .center, spacing: 0) {
                Text(transportType.description)
                    .foregroundColor(Color.primary)
                if currentValue == transportType {
                    Spacer()
                    Text("\(Image(systemName: "checkmark"))")
                }
            }
        }
    }
}

//struct TransportTypeOption_Previews: PreviewProvider {
//    static var previews: some View {
//        TransportTypeOption()
//    }
//}
