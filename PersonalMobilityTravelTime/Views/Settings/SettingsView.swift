//
//  SettingsView.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 26.07.2021.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var model: ContentModel
    
    @State var editMode: EditMode = .inactive
    
    var body: some View {
        List {
            Section(header: Text("My Devices")) {
                ForEach(model.devices) { device in
                    if editMode == .inactive {
                        NavigationLink(destination: EditingView(deviceToEdit: device)) {
                            DeviceMenuItem(imageName: device.iconName, label: device.title)
                        }
                    } else {
                        DeviceMenuItem(imageName: device.iconName, label: device.title)
                    }
                }
                .onMove(perform: move)
                .onLongPressGesture {
                    withAnimation {
                        editMode = .active
                    }
                }
            }
            
            NavigationLink(destination: EditingView(deviceToEdit: nil)) {
                NormalMenuItem(label: "Add device...")
            }
            
            Section(header: Text("Preferences")
            ) {
                NavigationLink(destination: UnitsOfMeasureView()) {
                    NormalMenuItem(icon: "ruler", label: "Distance units"/*, currentValue: self.model.units.fullDescription*/)
                }
            }
        }
        .toolbar {
            if model.devices.count > 1 {
                Button(editMode == .inactive ? String(localized: "Reorder") : String(localized: "Done")) {
                    if editMode == .inactive {
                        editMode = .active
                    } else {
                        editMode = .inactive
                    }
                }
                .buttonStyle(DefaultButtonStyle())
            }
        }
        .environment(\.editMode, $editMode)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        model.devices.move(fromOffsets: source, toOffset: destination)
        withAnimation {
            editMode = .active
        }
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(ContentModel())
    }
}
