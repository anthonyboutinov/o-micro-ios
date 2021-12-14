//
//  EditingView.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 26.07.2021.
//

import SwiftUI
//import PartialSheet

struct EditingView: View {
    
    @EnvironmentObject var model: ContentModel
    
    @ObservedObject var deviceToEdit: MobilityDevice
    
    @Environment(\.presentationMode) var presentationMode
    
    var isNew: Bool = false
    
    private var lengthFormatter = LengthFormatter()
    
    init(deviceToEdit: MobilityDevice?) {
        if let deviceToEdit = deviceToEdit  {
            self.deviceToEdit = deviceToEdit
        } else {
            self.isNew = true
            self.deviceToEdit = MobilityDevice(index: nil)
        }
    }
    
    @State var rangeInCurrentUnits: Double = 0.0 // is set on init
    
    enum FocusField: Hashable {
        case title
        case range
    }
    
    @FocusState private var focusedField: FocusField?
    
    var rangeProxy: Binding<String> {
        Binding<String>(
            get: {
                String(Double(self.rangeInCurrentUnits).removeZerosFromEnd(leaveFirst: 2))
            },
            set: {
                if !($0.last == "." || $0.last == ",") {
                    if let valueInCurrentUnits = NumberFormatter.byDefault(from: $0) {
                        self.rangeInCurrentUnits = valueInCurrentUnits.doubleValue
                        deviceToEdit.rangeKm = valueInCurrentUnits.doubleValue.inKilometers(model.units)
                    }
                }
            }
        )
    }
    
    var body: some View {
        
        List {
            Section {
                TextField("Title", text: $deviceToEdit.title) { isEditing in } onCommit: {
                    if !isNew {
                        model.updateDevice(deviceToEdit)
                    }
                }
                .autocapitalization(.words)
                .focused($focusedField, equals: .title)
                .onAppear {
                    if deviceToEdit.title == "" {
                        self.focusedField = .title
                    }
                }
                
                IconEditField(device: deviceToEdit)
            }
            
            Section {
                locationOfUseEditLink
            }
            
            Section {
                averageSpeedEditLink
            } footer: {
                Text("Fill in these details based on your experience with your micro-mobility device. Make a few rides and measure how you use it on average.")
            }
            
            Section {
                Toggle(isOn: self.$deviceToEdit.isElectric) {
                    Text("\(Image(systemName: "minus.plus.batteryblock")) Is electric")
                }
                
                if self.deviceToEdit.isElectric {
                    rangeInputField
                }
            }
            
            Section {
                // MARK: - Done/Delete Buttons
                
                if isNew == true {
                    DismissButton {
                        self.model.addDevice(deviceToEdit)
                    }
                    .disabled(!deviceToEdit.isValid())
                } else {
                    DeleteButton(device: deviceToEdit)
                }
            }
        }
            
        .onDisappear(perform: {
            model.updateDevice(deviceToEdit)
        })
        .navigationTitle("\(deviceToEdit.title == "" ? (isNew ? "New Device" : "Unnamed") : deviceToEdit.title)")
        .onAppear(perform: {
            self.rangeInCurrentUnits = deviceToEdit.rangeKm?.inCurrentUnits(model.units) ?? MobilityDevice.suggestedDefaultRangeKm.inCurrentUnits(model.units).rounded()
        })
    }
    
    private var averageSpeedEditLink: some View {
        NavigationLink {
            AverageSpeedCalculatorView(device: self.deviceToEdit)
        } label: {
            HStack {
                Text("Average speed")
                
                Spacer()
                
                Text(String(format: "%.2f", self.deviceToEdit.averageSpeedKmh.inCurrentUnits(model.units)))
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.trailing)
                
                Text(model.units.perHour)
                    .foregroundColor(Color.secondary)
//                    .frame(minWidth: 34, alignment: .trailing)
            }
            .foregroundColor(Color.primary)
        }
    }
    
    private var rangeInputField: some View {
        HStack {
            Text("Actual range")
            
            Spacer()
            
            TextField("", text: rangeProxy)
                .multilineTextAlignment(.trailing)
                .font(Font.system(size: Constants.UI.systemFontDefaultSize, weight: .semibold))
                .keyboardType(.decimalPad)
                .frame(maxWidth: 50)
                .focused($focusedField, equals: .range)
            
            Text(model.units.description)
                .foregroundColor(Color.secondary)
                .fontWeight(.regular)
        }
        .onAppear(perform: {
            lengthFormatter.isForPersonHeightUse = false
            lengthFormatter.numberFormatter.allowsFloats = true
        })
        .onTapGesture {
            focusedField = .range
        }
    }
    
    private var locationOfUseEditLink: some View {
        return NavigationLink {
            LocationOfUseView(device: deviceToEdit)
        } label: {
            HStack {
                Text("Location of use")
                
                Spacer()
                
                Text(deviceToEdit.transportType.description)
                    .foregroundColor(Color.secondary)
            }
        }
    }
}

struct EditingView_Previews: PreviewProvider {
    
    static var model = ContentModel()
    
    static var previews: some View {
        EditingView(deviceToEdit: nil)
            .environmentObject(model)
        
        EditingView(deviceToEdit: model.selectedDevice)
            .environmentObject(model)
    }
}
