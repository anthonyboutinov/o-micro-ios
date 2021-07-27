//
//  AverageSpeedCalculatorView.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 27.07.2021.
//

import SwiftUI

struct AverageSpeedCalculatorView: View {
    @Binding var distance: Double
    @Binding var time: Double
    @Binding var speed: Double
    
    @State private var distanceLabel: String = ""
    @State private var timeLabel: String = ""
    @State private var speedLabel: String = ""
    
    @Binding var changeApproved: Bool
    @Binding var isSheetShown: Bool
    
    private func getSpeed() -> Double {
        return time > 0 ? distance / time * 60.0 : 0
    }
    
    private func setSpeedLabel() {
        let speed = getSpeed()
        if speed > 0 {
            self.speedLabel = String(format: "%.2f", speed)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.UI.compactSpacing) {
            Text("Average Speed Calculator")
                .modifierSheetTitle()
            
            VStack(alignment: .leading, spacing: Constants.UI.itemSpacing) {
                
                Text("Record your routine commute using any other app and enter how long it takes you to travel some distance. Alternatively, you can enter average speed manually.")
                    .modifierBodyText()
                    
                
                HStack {
                    Text("Distance")
                    
                    Spacer()
                    
                    TextField("", text: $distanceLabel) { bool in
                        
                    } onCommit: {}
                    .multilineTextAlignment(.trailing)
                    .font(Font.system(size: 14, weight: .semibold))
                    .keyboardType(.decimalPad)
                    
                    Text("km")
                        .foregroundColor(Constants.Colors.graphite)
                        .fontWeight(.regular)
                        .frame(minWidth: 34, alignment: .trailing)
                }
                .modifier(InputFieldViewModifier())
                
                HStack {
                    Text("Travel Time")
                    
                    Spacer()
                    
                    TextField("", text: $timeLabel) { bool in
                        
                    } onCommit: {}
                    .multilineTextAlignment(.trailing)
                    .font(Font.system(size: 14, weight: .semibold))
                    .keyboardType(.numberPad)
                    
                    Text("min")
                        .foregroundColor(Constants.Colors.graphite)
                        .fontWeight(.regular)
                        .frame(minWidth: 34, alignment: .trailing)
                }
                .modifier(InputFieldViewModifier())
                
                HStack {
                    Text("Average Speed")
                    
                    Spacer()
                    
                    TextField("", text: $speedLabel) { bool in
                        
                    } onCommit: {}
                    .multilineTextAlignment(.trailing)
                    .font(Font.system(size: 14, weight: .semibold))
                    .keyboardType(.decimalPad)
                    
                    Text("km/h")
                        .foregroundColor(Constants.Colors.graphite)
                        .fontWeight(.regular)
                        .frame(minWidth: 34, alignment: .trailing)
                }
                .modifier(InputFieldViewModifier())
                .padding(.top, 25.0)
                
            }
//            .padding(.bottom, Constants.UI.sectionSpacing)
            
            // #MARK: - Completion Buttons
            
            HStack(alignment: .center, spacing: Constants.UI.itemSpacing, content: {
                
                Button(action: {
                    changeApproved = false
                    isSheetShown = false
                }, label: {
                    Text("Cancel")
                })
                .buttonStyle(PlainLikeButtonStyle(.cancel))
                
                Button(action: {
                    // change approved by default, no need to set it to true
                    isSheetShown = false
                }, label: {
                    Text("Done")
                })
                .buttonStyle(PlainLikeButtonStyle(.white))
                
            })
            
        }
        .padding(.bottom, Constants.UI.sheetBottomPadding)
        .padding(.horizontal, Constants.UI.horizontalSectionSpacing)
        .onAppear(perform: {
            distanceLabel = distance > 0 ? String(format: "%.2f", distance) : ""
            timeLabel = time > 0 ? String(format: "%.0f", time) : ""
            speedLabel = speed > 0 ? String(format: "%.2f", speed) : ""
        })
        .onChange(of: distanceLabel, perform: { value in
            if let double = Double(value) {
                distance = double
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
            if let double = Double(value) {
                speed = double
            }
        })
    }
}

struct AverageSpeedCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        AverageSpeedCalculatorView(distance: .constant(20.1854159), time: .constant(45), speed: .constant(15.1045141), changeApproved: .constant(true), isSheetShown: .constant(true))
            .previewLayout(.sizeThatFits)
    }
}
