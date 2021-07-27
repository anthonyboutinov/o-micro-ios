//
//  EditingView.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 26.07.2021.
//

import SwiftUI
import PartialSheet

struct EditingView: View {
    
    @EnvironmentObject var model: ContentModel
    @EnvironmentObject var partialSheetManager: PartialSheetManager
    
    @ObservedObject var deviceToEdit: MobilityDevice // = MobilityDevice(index: nil)
    
    @State var isNew: Bool = false
    
//    var addingNewDevice = false
    
    private var lengthFormatter = LengthFormatter()
        
//    init(deviceToEdit: MobilityDevice?) {
//        self.isNew = deviceToEdit == nil
// //        self.deviceToEdit = deviceToEdit ?? MobilityDevice(index: nil)
//    }
    
    init(deviceToEdit: MobilityDevice?) {
        if let deviceToEdit = deviceToEdit  {
            self.deviceToEdit = deviceToEdit
        } else {
            self.isNew = true
            self.deviceToEdit = MobilityDevice(index: nil)
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Constants.UI.sectionSpacing) {
                VStack(alignment: .leading, spacing: Constants.UI.itemSpacing) {
                    Text("General Properties")
                        .font(.title3)
                        .foregroundColor(Constants.Colors.graphite)
                    
                    
                    HStack {
                        Text("Title")
                        TextField("", text: $deviceToEdit.title) { isEditing in
                            
                        } onCommit: {}
                        .multilineTextAlignment(.trailing)
                        .font(Font.system(size: 14, weight: .semibold))
                    }
                    .modifier(InputFieldViewModifier())
                    
                    IconEditField(iconName: self.$deviceToEdit.iconName)
                    
                    IsElectricEditField(isElectric: self.$deviceToEdit.isElectric)
                }
                
                VStack(alignment: .leading, spacing: Constants.UI.itemSpacing) {
                    Text("Usage Stats")
                        .font(.title3)
                        .foregroundColor(Constants.Colors.graphite)
                    
                    Text("Fill in the following details based on your experience with your micro-mobility device. Make a few rides and measure how on average you use it.")
                        .modifierBodyText()
                    
                    AverageSpeedEditField(device: deviceToEdit)
                    
                    if self.deviceToEdit.isElectric == true {
                        HStack {
                            Text("Distance Travelled on Full Charge")
                            
                            Spacer()
                            
                            TextField("", value: $deviceToEdit.distanceOnFullChargeKm, formatter: lengthFormatter) { isEditing in
                            } onCommit: {}
                            .multilineTextAlignment(.trailing)
                            .font(Font.system(size: 14, weight: .semibold))
                            .keyboardType(.decimalPad)
                            .frame(maxWidth: 50)
                            
                            Text("km/h")
                                .foregroundColor(Constants.Colors.graphite)
                                .fontWeight(.regular)
                                .frame(minWidth: 34, alignment: .trailing)
                        }
                        .modifier(InputFieldViewModifier())
                        .onAppear(perform: {
                            lengthFormatter.isForPersonHeightUse = false
                            lengthFormatter.numberFormatter.allowsFloats = true
                        })
                    }
                    
                }
                
                // MARK: - Done/Delete Buttons
                
                Spacer()
                
                if isNew == true {
                    Button(action: {
                        model.addDevice(deviceToEdit)
                    }, label: {
                        Text("Done")
                    })
                    .buttonStyle(PlainLikeButtonStyle(.primary))
                } else {
                    DeleteButton(deviceToEdit: deviceToEdit)
                }
            }
            .padding(.horizontal, Constants.UI.horizontalSectionSpacing)
            .padding(.vertical, Constants.UI.verticalSectionSpacing)
        }
        .onDisappear(perform: {
            model.updateDevice(deviceToEdit)
        })
    }
}

struct EditingView_Previews: PreviewProvider {
    static var previews: some View {
        EditingView(deviceToEdit: nil)
            .environmentObject(ContentModel())
            .environmentObject(PartialSheetManager())
    }
}
