//
//  AverageSpeedCalculatorView.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 27.07.2021.
//

import SwiftUI

struct AverageSpeedCalculatorView: View {
    
    @EnvironmentObject var model: ContentModel
    
    @ObservedObject var device: MobilityDevice
    
    @State private var distance: Double = 0
    @State private var time: Double = 0
    @State private var speed: Double = 0
    
    @State private var distanceLabel: String = ""
    @State private var timeLabel: String = ""
    @State private var speedLabel: String = ""
    
    @State private var changeApproved: Bool = true
    
    private func getSpeed() -> Double {
        return time > 0 ? distance / time * 60.0 : 0
    }
    
    private func setSpeedLabel() {
        let speed = getSpeed()
        if speed > 0 {
            self.speedLabel = String(format: "%.2f", speed.inCurrentUnits(model.units))
        }
    }
    
    private enum FocusField: Hashable {
        case distance
        case travelTime
        case averageSpeed
    }
    
    @FocusState private var focusedField: FocusField?
    
    var body: some View {
        
        List {
            Section {
                distanceInputField()
                travelTimeInputField()
            } header: {
                Text("Average Speed Calculator")
            } footer: {
                Text("Record your routine commute using any other app and enter how long it takes you to travel some distance. Alternatively, you can enter the average speed manually.")
            }
            
            Section {
                averageSpeedInputField()
            }
            
            Section {
                DismissButton(action: nil)
            }
        }
        .toolbar {
            cancelButton()
        }
        .navigationTitle("Average Speed")
        .onAppear(perform: {
            distance = device.averageSpeedCalculatorData?.distanceKm ?? 0
            time = device.averageSpeedCalculatorData?.travelTimeMinutes ?? 0
            speed = device.averageSpeedKmh
            
            distanceLabel = distance > 0 ? String(format: "%.2f", distance.inCurrentUnits(model.units)) : ""
            timeLabel = time > 0 ? String(format: "%.0f", time) : ""
            speedLabel = speed > 0 ? String(format: "%.2f", speed.inCurrentUnits(model.units)) : ""
        })
        .onChange(of: distanceLabel, perform: { value in
            if let distanceInCurrentUnits = Double(value) {
                distance = distanceInCurrentUnits.inKilometers(model.units)
            }
            setSpeedLabel()
        })
        .onChange(of: timeLabel, perform: { value in
            if let double = Double(value) {
                time = double
            }
            setSpeedLabel()
        })
        .onChange(of: speedLabel, perform: { value in
            if let speedInCurrentUnits = Double(value) {
                speed = speedInCurrentUnits.inKilometers(model.units)
            }
        })
        .onDisappear {
            if changeApproved {
                device.averageSpeedKmh = speed
                device.averageSpeedCalculatorData = MobilityDevice.AverageSpeedCalculatorData(distanceKm: distance, travelTimeMinutes: time)
            }
        }
    }
    
    // MARK: - distanceInputField
    private func distanceInputField() -> some View {
        return HStack {
            Text("Distance")
            
            TextField("0", text: $distanceLabel) { isEditing in } onCommit: {
                self.focusedField = .travelTime
            }
            .multilineTextAlignment(.trailing)
            .keyboardType(.decimalPad)
            .focused($focusedField, equals: .distance)
            .font(Font.system(size: Constants.UI.systemFontDefaultSize,weight: .semibold))
            .onAppear {
                self.focusedField = .distance
            }
            
            Text(model.units.description)
                .foregroundColor(Constants.Colors.graphite)
                .frame(minWidth: Constants.UI.unitsMinWidth, alignment: .trailing)
        }
        .onTapGesture {
            self.focusedField = .distance
        }
    }
    
    // MARK: - travelTimeInputField
    private func travelTimeInputField() -> some View {
        return HStack {
            Text("Travel Time")
            
            TextField("0", text: $timeLabel) { isEditing in } onCommit: {
                if distance == 0 {
                    focusedField = .distance
                }
            }
            .multilineTextAlignment(.trailing)
            .keyboardType(.numberPad)
            .focused($focusedField, equals: .travelTime)
            .font(Font.system(size: Constants.UI.systemFontDefaultSize,weight: .semibold))
            
            Text("min")
                .foregroundColor(Constants.Colors.graphite)
                .frame(minWidth: Constants.UI.unitsMinWidth, alignment: .trailing)
        }
        .onTapGesture {
            self.focusedField = .travelTime
        }
    }
    
    // MARK: - averageSpeedInputField
    private func averageSpeedInputField() -> some View {
        return HStack {
            Text("Average Speed")
            
            TextField("0", text: $speedLabel) { isEditing in } onCommit: {}
            .multilineTextAlignment(.trailing)
            .font(Font.system(size: Constants.UI.systemFontDefaultSize, weight: .semibold))
            .keyboardType(.decimalPad)
            .focused($focusedField, equals: .averageSpeed)
            .onTapGesture {
                time = 0
                timeLabel = ""
                distance = 0
                distanceLabel = ""
            }
            
            Text(model.units.perHour)
                .foregroundColor(Constants.Colors.graphite)
                .fontWeight(.regular)
                .frame(minWidth: Constants.UI.unitsMinWidth, alignment: .trailing)
        }
        .onTapGesture {
            self.focusedField = .averageSpeed
        }
    }
    
    // MARK: - Cancel
    
    @Environment(\.presentationMode) var presentationMode
    
    private func cancelButton() -> some View {
        return Button {
            self.changeApproved = false
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text("Cancel")
        }
    }
    
}

struct AverageSpeedCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        AverageSpeedCalculatorView(device: MobilityDevice.sample())
            .previewLayout(.sizeThatFits)
            .environmentObject(ContentModel.PreviewInImperialUnits)
    }
}
