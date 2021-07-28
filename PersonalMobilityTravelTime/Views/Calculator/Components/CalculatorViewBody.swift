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
                        .foregroundColor(Constants.Colors.graphite)
                    
                    HStack {
                        Text("Distance")
                        
                        Spacer()
                        
                        TextField("", text: calculator.distanceProxy)
                        .multilineTextAlignment(.trailing)
                        .font(Font.system(size: 14, weight: .semibold))
                        .keyboardType(.decimalPad)
                        
                        Text("km")
                            .foregroundColor(Constants.Colors.graphite)
                            .fontWeight(.regular)
                            .frame(minWidth: 34, alignment: .trailing)
                    }
                    .modifier(InputFieldViewModifier())
                }
                
                // MARK: - Calculated Values
                VStack(alignment: .leading, spacing: Constants.UI.itemSpacing) {
                    Text("Calculated Values")
                        .font(.title3)
                        .foregroundColor(Constants.Colors.graphite)
                    
                    HStack {
                        Text("Time to Travel")
                        
                        Spacer()
                        
                        Text(calculator.timeToTravelLabel)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.trailing)
                        
                        Text(calculator.timeToTravelUnits)
                            .foregroundColor(Constants.Colors.graphite)
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
