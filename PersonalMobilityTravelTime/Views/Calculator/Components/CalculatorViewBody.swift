//
//  CalculatorViewBody.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 28.07.2021.
//

import SwiftUI

struct CalculatorViewBody: View {
    
    static let unitsMinWidth: CGFloat = 34
    
    @EnvironmentObject var model: ContentModel
    
    @ObservedObject var calculator: CalculatorModel
    
    @Binding var distanceInCurrentUnits: Double
    
    var distanceProxy: Binding<String> {
        Binding<String>(
            get: {
                self.distanceInCurrentUnits > 0 ? Double(self.distanceInCurrentUnits).removeZerosFromEnd(leaveFirst: 2) : ""
            },
            set: {
                if !($0.last == "." || $0.last == ",") {
                    if let valueInCurrentUnits = NumberFormatter.byDefault(from: $0) {
                        self.distanceInCurrentUnits = valueInCurrentUnits.doubleValue
                    }
                }
            }
        )
    }
    
    enum FocusField: Hashable {
        case distance
    }
    
    @FocusState private var focusedField: FocusField?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Constants.UI.sectionSpacing) {
                enterTripDetailsSection()
                calculatedValuesSection()
            }
            .padding(.horizontal, Constants.UI.horizontalSectionSpacing)
            .padding(.bottom, Constants.UI.verticalSectionSpacing)
            .padding(.top, Constants.UI.sectionSpacing)
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
    
    /// Enter Your Trip Details Section
    private func enterTripDetailsSection() -> some View {
        VStack(alignment: .leading, spacing: Constants.UI.itemSpacing) {
            Text("Enter Your Trip Details")
                .font(.title3)
                .foregroundColor(Color.secondary)
            
            HStack {
                Text("Distance")
                    .font(.body)
                
                Spacer()
                
                TextField("0", text: distanceProxy)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
                    .focused($focusedField, equals: .distance)
                    .font(.body.weight(.semibold))
                    .onAppear {
                        focusedField = .distance
                    }
                
                Text(model.units.name)
                    .foregroundColor(Color.secondary)
                    .font(.body)
                    .frame(minWidth: Self.unitsMinWidth, alignment: .trailing)
            }
            .modifier(InputFieldViewModifier())
            .onTapGesture {
                self.focusedField = .distance
            }
        }
    }
    
    /// Calculated Values Section
    private func calculatedValuesSection() -> some View {
        VStack(alignment: .leading, spacing: Constants.UI.itemSpacing) {
            Text("Calculated Values")
                .font(.title3)
                .foregroundColor(Color.secondary)
            
            timeToTravel()
            
            if model.selectedDevice!.isElectric {
                batteryUsage()
            }
            
            Spacer()
        }
    }
    
    /// Time to Travel Row
    private func timeToTravel() -> some View {
        HStack {
            Text("Time to Travel")
                .font(.body)
            
            Spacer()
            
            Text(calculator.timeToTravelLabel)
                .font(.body.weight(.semibold))
                .multilineTextAlignment(.trailing)
            
            Text(calculator.timeToTravelUnits)
                .foregroundColor(Color.secondary)
                .font(.body)
                .frame(minWidth: Self.unitsMinWidth, alignment: .leading)
        }
        .modifier(InputFieldViewModifier())
    }
    
    /// Battery Usage Row
    private func batteryUsage() -> some View {
        HStack {
            Text("Battery Usage")
                .font(.body)
            
            Spacer()
            
            Text(calculator.batteryUsageLabel)
                .font(.body.weight(.semibold))
                .multilineTextAlignment(.trailing)
            
            Text(String("%"))
                .foregroundColor(Color.secondary)
                .font(.body)
                .frame(minWidth: Self.unitsMinWidth, alignment: .leading)
        }
        .modifier(InputFieldViewModifier())
    }
}

struct CalculatorViewBody_Previews: PreviewProvider {
    @State static var distance: Double = 0.0
    static var previews: some View {
        CalculatorViewBody(calculator: CalculatorModel(averageSpeedKmh: 10, batteryRange: 14, distance: 5), distanceInCurrentUnits: $distance)
            .previewLayout(.sizeThatFits)
            .environmentObject(ContentModel.preview())
    }
}
