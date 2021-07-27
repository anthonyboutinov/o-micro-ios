//
//  DeleteButton.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 28.07.2021.
//

import SwiftUI

struct DeleteButton: View {
    
    @EnvironmentObject var model: ContentModel
    
    @ObservedObject var deviceToEdit: MobilityDevice
    
    @State private var showAlert = false
    
    var body: some View {
        Button(action: {
            showAlert = true
        }, label: {
            Text("Delete \(deviceToEdit.title == "" ? "Device" : deviceToEdit.title)")
        })
        .buttonStyle(PlainLikeButtonStyle(.destructive))
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Delete \(deviceToEdit.title == "" ? "Device" : deviceToEdit.title)?"),
                primaryButton: .default(
                    Text("Cancel"),
                    action: {}
                ),
                secondaryButton: .destructive(
                    Text("Delete"),
                    action: {
                        model.deleteDevice(deviceToEdit)
                    }
                )
            )
        }
    }
}

//struct DeleteButton_Previews: PreviewProvider {
//    static var previews: some View {
//        DeleteButton()
//    }
//}
