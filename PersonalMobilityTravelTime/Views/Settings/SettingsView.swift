//
//  SettingsView.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 26.07.2021.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Constants.UI.sectionSpacing) {
                
                VStack(alignment: .leading, spacing: Constants.UI.itemSpacing) {
                    HStack {
                        Text("My Devices")
                            .foregroundColor(.gray)
                            .font(.title2)
                        Spacer()
                        Button(action: {
                            
                        }, label: {
                            Text("Reorder")
                        })
                        .buttonStyle(DefaultButtonStyle())
                    }
                    ForEach(model.devices) { device in
                        NavigationLink(destination: EditingView(deviceToEdit: device)) {
                            DeviceMenuItem(imageName: device.iconName, label: device.title)
                        }
                    }
                    NavigationLink(destination: EditingView(deviceToEdit: nil)) {
                        CenteredMenuItem(icon: "plus.circle", label: "Add Device")
                    }
                    .buttonStyle(PlainLikeButtonStyle())
                }
                
                VStack(alignment: .leading, spacing: Constants.UI.itemSpacing) {
                    Text("Preferences")
                        .foregroundColor(.gray)
                        .font(.title2)
                    NavigationLink(destination: Text("Not Set")) {
                        NormalMenuItem(icon: "ruler", label: "Units of Measure")
                    }
                }
                
                VStack(alignment: .leading, spacing: Constants.UI.itemSpacing) {
                    Text("Other")
                        .foregroundColor(.gray)
                        .font(.title2)
                    NavigationLink(destination: Text("Not Set")) {
                        NormalMenuItem(icon: "app", label: "Would You Like to Develop an App?")
                    }
                    NavigationLink(destination: Text("Not Set")) {
                        NormalMenuItem(icon: "lifepreserver", label: "Support")
                    }
                    NavigationLink(destination: Text("Not Set")) {
                        NormalMenuItem(icon: "checkmark.shield", label: "Privacy Policy")
                    }
                    NavigationLink(destination: Text("Not Set")) {
                        NormalMenuItem(icon: "doc.text", label: "Terms of Use")
                    }
                }
                
                
                Spacer()
                
            }
            .padding(.horizontal, Constants.UI.horizontalSectionSpacing)
            .padding(.vertical, Constants.UI.verticalSectionSpacing)
            .buttonStyle(MenuLikeButtonStyle())
        }
        .navigationTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(ContentModel())
    }
}
