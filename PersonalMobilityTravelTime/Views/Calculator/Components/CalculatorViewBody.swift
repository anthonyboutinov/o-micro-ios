//
//  CalculatorViewBody.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 28.07.2021.
//

import SwiftUI

struct CalculatorViewBody: View {
    
    @EnvironmentObject var model: ContentModel
    
    @ObservedObject var calculator = CalculatorModel()
    
    @State var distanceInCurrentUnits = 0.0
    
    var distanceProxy: Binding<String> {
        Binding<String>(
            get: {
                Double(self.distanceInCurrentUnits).removeZerosFromEnd(leaveFirst: 2)
            },
            set: {
                if !($0.last == "." || $0.last == ",") {
                    if let valueInCurrentUnits = NumberFormatter.byDefault(from: $0) {
                        self.distanceInCurrentUnits = valueInCurrentUnits.doubleValue
                        calculator.distance = valueInCurrentUnits.doubleValue.inKilometers(model.units)
                        self.update()
                    }
                }
            }
        )
    }
    
    enum FocusField: Hashable {
        case distance
    }
    
    @FocusState private var focusedField: FocusField?
    
    private func update() {
        calculator.averageSpeedKmh = model.selectedDevice!.averageSpeedKmh
        calculator.update()
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Constants.UI.sectionSpacing) {
                
                // MARK: - Enter Your Trip Details
                VStack(alignment: .leading, spacing: Constants.UI.itemSpacing) {
                    Text("Enter Your Trip Details")
                        .font(.title3)
                        .foregroundColor(Color.secondary)
                    
                    HStack {
                        Text("Distance")
                        
                        Spacer()
                        
                        TextField("", text: distanceProxy)
                            .multilineTextAlignment(.trailing)
                            .font(Font.system(size: 14, weight: .semibold))
                            .keyboardType(.decimalPad)
                            .focused($focusedField, equals: .distance)
                        
                        Text(model.units.description)
                            .foregroundColor(Color.secondary)
                            .fontWeight(.regular)
                            .frame(minWidth: 34, alignment: .trailing)
                    }
                    .modifier(InputFieldViewModifier())
                    .onTapGesture {
                        self.focusedField = .distance
                    }
                }
                
                // MARK: - Calculated Values
                VStack(alignment: .leading, spacing: Constants.UI.itemSpacing) {
                    Text("Calculated Values")
                        .font(.title3)
                        .foregroundColor(Color.secondary)
                    
                    HStack {
                        Text("Time to Travel")
                        
                        Spacer()
                        
                        Text(calculator.timeToTravelLabel)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.trailing)
                        
                        Text(calculator.timeToTravelUnits)
                            .foregroundColor(Color.secondary)
                            .fontWeight(.regular)
                            .frame(minWidth: 34, alignment: .trailing)
                    }
                    .modifier(InputFieldViewModifier())
                    
                    Spacer()
                }
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
            }
        }
        .onAppear(perform: {
            update()
        })
    }
}

struct CalculatorViewBody_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorViewBody()
            .previewLayout(.sizeThatFits)
            .environmentObject(ContentModel())
    }
}
