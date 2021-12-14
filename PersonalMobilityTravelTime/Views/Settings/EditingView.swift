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
    //    @EnvironmentObject var partialSheetManager: PartialSheetManager
    
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
                
                IconEditField(iconName: self.$deviceToEdit.iconName)
            }
            
            Section {
                averageSpeedEditField
                
                Toggle(isOn: self.$deviceToEdit.isElectric) {
                    Text("\(Image(systemName: "minus.plus.batteryblock")) Is electric")
                }
                
                if self.deviceToEdit.isElectric {
                    HStack {
                        Text("Actual range")
                        
                        Spacer()
                        
                        TextField("", text: rangeProxy)
                            .multilineTextAlignment(.trailing)
                            .font(Font.system(size: Constants.UI.systemFontDefaultSize, weight: .semibold))
                            .keyboardType(.decimalPad)
                            .frame(maxWidth: 50)
                        
                        Text(model.units.description)
                            .foregroundColor(Constants.Colors.graphite)
                            .fontWeight(.regular)
//                            .frame(minWidth: Constants.UI.unitsMinWidth, alignment: .trailing)
                    }
//                    .modifier(InputFieldViewModifier())
                    .onAppear(perform: {
                        lengthFormatter.isForPersonHeightUse = false
                        lengthFormatter.numberFormatter.allowsFloats = true
                    })
                }
            } header: {
                Text("Specs")
            } footer: {
                Text("Fill in these details based on your experience with your micro-mobility device. Make a few rides and measure how you use it on average.")
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

//        }
        
//        ScrollView {
//            VStack(alignment: .leading, spacing: Constants.UI.sectionSpacing) {
//                if model.setUpProcess == .addFirstDevice {
//                    Text(deviceToEdit.title == "" ? "New Device" : deviceToEdit.title)
//                        .font(.largeTitle)
//                        .bold()
//                        .autocapitalization(.words)
//                }
                
//                VStack(alignment: .leading, spacing: Constants.UI.itemSpacing) {
//                    Text("General Properties")
//                        .font(.title3)
//                        .foregroundColor(Constants.Colors.graphite)
//
//
//                    HStack {
//                        Text("Title")
//                        TextField("", text: $deviceToEdit.title) { isEditing in
//
//                        } onCommit: {
//                            if !isNew && deviceToEdit.isValid() {
//                                model.updateDevice(deviceToEdit)
//                            }
//                        }
//                        .multilineTextAlignment(.trailing)
//                        .font(Font.system(size: 14, weight: .semibold))
//                        .autocapitalization(.words)
//                        .focused($focusedField, equals: .title)
//                        .onAppear {
//                            if deviceToEdit.title == "" {
//                                self.focusedField = .title
//                            }
//                        }
//                    }
//                    .modifier(InputFieldViewModifier())
//                    .onTapGesture {
//                        self.focusedField = .title
//                    }
//
//                    IconEditField(iconName: self.$deviceToEdit.iconName)
                    
//                    IsElectricEditField(isElectric: self.$deviceToEdit.isElectric)
//                }
//
//                VStack(alignment: .leading, spacing: Constants.UI.itemSpacing) {
//                    Text("Usage Stats")
//                        .font(.title3)
//                        .foregroundColor(Constants.Colors.graphite)
//
//                    Text("Fill in the following details based on your experience with your micro-mobility device. Make a few rides and measure how on average you use it.")
//                        .modifierBodyText()
//
//                    AverageSpeedEditField(device: deviceToEdit)
//
//                    if self.deviceToEdit.isElectric == true {
//                        HStack {
//                            Text("Distance Travelled on Full Charge")
//
//                            Spacer()
//
//                            TextField("", text: rangeProxy)
//                                .multilineTextAlignment(.trailing)
//                                .font(Font.system(size: 14, weight: .semibold))
//                                .keyboardType(.decimalPad)
//                                .frame(maxWidth: 50)
//
//                            Text(model.units.description)
//                                .foregroundColor(Constants.Colors.graphite)
//                                .fontWeight(.regular)
//                                .frame(minWidth: 34, alignment: .trailing)
//                        }
//                        .modifier(InputFieldViewModifier())
//                        .onAppear(perform: {
//                            lengthFormatter.isForPersonHeightUse = false
//                            lengthFormatter.numberFormatter.allowsFloats = true
//                        })
//                    }
//
//                }
                
//                // MARK: - Done/Delete Buttons
//
//                if isNew == true {
//                    Button(action: {
//                        model.addDevice(deviceToEdit)
//                        presentationMode.wrappedValue.dismiss()
//                    }, label: {
//                        Text("Done")
//                    })
//                        .buttonStyle(PlainLikeButtonStyle(.primary))
//                        .disabled(!deviceToEdit.isValid())
//                } else {
//                    DeleteButton(deviceToEdit: deviceToEdit)
//                }
//            }
//            .padding(.horizontal, Constants.UI.horizontalSectionSpacing)
//            .padding(.vertical, Constants.UI.verticalSectionSpacing)
        }
            
        .onDisappear(perform: {
            model.updateDevice(deviceToEdit)
        })
        .navigationTitle("\(deviceToEdit.title == "" ? (isNew ? "New Device" : "Unnamed") : deviceToEdit.title)")
        .onAppear(perform: {
            self.rangeInCurrentUnits = deviceToEdit.rangeKm?.inCurrentUnits(model.units) ?? MobilityDevice.suggestedDefaultRangeKm.inCurrentUnits(model.units).rounded()
        })
    }
    
    private var averageSpeedEditField: some View {
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
                    .foregroundColor(Constants.Colors.graphite)
//                    .frame(minWidth: 34, alignment: .trailing)
            }
            .foregroundColor(Color.primary)
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
