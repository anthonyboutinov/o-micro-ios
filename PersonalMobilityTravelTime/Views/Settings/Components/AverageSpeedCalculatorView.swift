//
//  AverageSpeedCalculatorView.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 27.07.2021.
//

import SwiftUI

struct AverageSpeedCalculatorView: View {
    
    @EnvironmentObject var model: ContentModel
    
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
            self.speedLabel = String(format: "%.2f", speed.inCurrentUnits(model.units))
        }
    }
    
    enum FocusField: Hashable {
        case distance
        case travelTime
        case averageSpeed
    }
    
    @FocusState private var focusedField: FocusField?
    
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
                    
                    TextField("", text: $distanceLabel) { isEditing in
                        
                    } onCommit: {}
                    .multilineTextAlignment(.trailing)
                    .font(Font.system(size: 14, weight: .semibold))
                    .keyboardType(.decimalPad)
                    .focused($focusedField, equals: .distance)
                    .onAppear {
                        self.focusedField = .distance
                    }
                    
                    Text(model.units.description)
                        .foregroundColor(Constants.Colors.graphite)
                        .fontWeight(.regular)
                        .frame(minWidth: 34, alignment: .trailing)
                }
                .modifier(InputFieldViewModifier())
                .onTapGesture {
                    self.focusedField = .distance
                }
                
                HStack {
                    Text("Travel Time")
                    
                    Spacer()
                    
                    TextField("", text: $timeLabel) { isEditing in
                        
                    } onCommit: {}
                    .multilineTextAlignment(.trailing)
                    .font(Font.system(size: 14, weight: .semibold))
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .travelTime)
                    
                    Text("min")
                        .foregroundColor(Constants.Colors.graphite)
                        .fontWeight(.regular)
                        .frame(minWidth: 34, alignment: .trailing)
                }
                .modifier(InputFieldViewModifier())
                .onTapGesture {
                    self.focusedField = .travelTime
                }
                
                HStack {
                    Text("Average Speed")
                    
                    Spacer()
                    
                    TextField("", text: $speedLabel) { isEditing in
                        
                    } onCommit: {}
                    .multilineTextAlignment(.trailing)
                    .font(Font.system(size: 14, weight: .semibold))
                    .keyboardType(.decimalPad)
                    .focused($focusedField, equals: .averageSpeed)
                    
                    Text(model.units.perHour)
                        .foregroundColor(Constants.Colors.graphite)
                        .fontWeight(.regular)
                        .frame(minWidth: 34, alignment: .trailing)
                }
                .modifier(InputFieldViewModifier())
                .padding(.top, 25.0)
                .onTapGesture {
                    self.focusedField = .averageSpeed
                }
                
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
    }
}

struct AverageSpeedCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        AverageSpeedCalculatorView(distance: .constant(20.1854159), time: .constant(45), speed: .constant(15.1045141), changeApproved: .constant(true), isSheetShown: .constant(true))
            .previewLayout(.sizeThatFits)
            .environmentObject(ContentModel.PreviewInImperialUnits)
    }
}
