//
//  DeleteButton.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 28.07.2021.
//

import SwiftUI

struct DeleteButton: View {
    
    @EnvironmentObject var model: ContentModel
    
    @ObservedObject var device: MobilityDevice
    
    @State private var showAlert = false
    
    @Environment(\.presentationMode) var presentationMode
    
    private var deleteText: String {
        if device.title == "" {
            return String(localized: "Delete Device")
        } else {
            return String(localized: "Delete \(device.title)")
        }
    }
    
    var body: some View {
        Button {
            showAlert = true
        } label: {
            Text(deleteText)
                .frame(maxWidth: .infinity)
        }
        .foregroundColor(Constants.Colors.red)
        .alert(isPresented: $showAlert) {
            alert
        }
    }
    
    private var alert: Alert {
        return Alert(
            title: Text("\(deleteText)?"),
            primaryButton: .default(
                Text("Cancel"),
                action: {}
            ),
            secondaryButton: .destructive(
                Text("Delete"),
                action: {
                    model.deleteDevice(device)
                    presentationMode.wrappedValue.dismiss()
                }
            )
        )
    }
}

//struct DeleteButton_Previews: PreviewProvider {
//    static var previews: some View {
//        DeleteButton()
//    }
//}
