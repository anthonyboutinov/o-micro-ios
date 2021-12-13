//
//  SettingsView.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 26.07.2021.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var model: ContentModel
    
    @State var reorderingItems = false
    
    var body: some View {
        List {
            Section(header: HStack {
                Text("My Devices")
            }) {
                ForEach(model.devices) { device in
                    NavigationLink(destination: EditingView(deviceToEdit: device)) {
                        DeviceMenuItem(imageName: device.iconName, label: device.title)
                    }
                }
                .environment(\.editMode, self.reorderingItems ? .constant(.active) : .constant(.inactive))
            }
            
            NavigationLink(destination: EditingView(deviceToEdit: nil)) {
                NormalMenuItem(label: "Add Device...")
            }
            
            Section(header: Text("Preferences")
            ) {
                NavigationLink(destination: UnitsOfMeasureView()) {
                    NormalMenuItem(icon: "ruler", label: "Units of Measure"/*, currentValue: self.model.units.fullDescription*/)
                }
            }
            
            //                VStack(alignment: .leading, spacing: Constants.UI.itemSpacing) {
            //            Section(header: Text("Other")
            ////                        .foregroundColor(Constants.Colors.graphite)
            ////                        .font(.title2)
            //            ) {
            
            //                    NavigationLink(destination: Text("Not Set")) {
            //                        NormalMenuItem(/*icon: "app", */label: "Would You Like to Develop an App?")
            //                    }
            //                    NavigationLink(destination: Text("Not Set")) {
            //                        NormalMenuItem(/*icon: "lifepreserver",  */label: "Support")
            //                    }
            //                    NavigationLink(destination: Text("Not Set")) {
            //                        NormalMenuItem(icon: "checkmark.shield", label: "Privacy Policy")
            //                    }
            //                    NavigationLink(destination: Text("Not Set")) {
            //                        NormalMenuItem(icon: "doc.text", label: "Terms of Use")
            //                    }
            //                }
            
            //            }
            
        }
        .toolbar {
            if model.devices.count > 1 {
                Button("Reorder") {
                    //...
                }
                .buttonStyle(DefaultButtonStyle())
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(ContentModel())
    }
}
