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
    
    @State var deviceToEdit: MobilityDevice
    
    @State var isNew: Bool
        
    init(deviceToEdit: MobilityDevice?) {
        self.isNew = deviceToEdit == nil
        self.deviceToEdit = deviceToEdit ?? MobilityDevice(index: nil)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.UI.sectionSpacing) {
            VStack(alignment: .leading, spacing: Constants.UI.itemSpacing) {
                Text("General Properties")
                    .font(.title3)
                    .foregroundColor(Constants.Colors.graphite)
                
                
                HStack {
                    Text("Title")
                    TextField("", text: $deviceToEdit.title) { bool in
                        
                    } onCommit: {
                        
                    }
                    .multilineTextAlignment(.trailing)
                    .font(Font.system(size: 14, weight: .semibold))
                }
                .modifier(InputFieldViewModifier())
                
                IconEditField(iconName: self.$deviceToEdit.iconName)
                
                Button(action: {
                    self.partialSheetManager.showPartialSheet({
                        print("Partial sheet dismissed")
                    }) {
                        Text("This is a Partial Sheet")
                    }
                }) {
                    HStack {
                        Text("Is It Electric")
                        Spacer()
                        Text(deviceToEdit.isElectric ? "Yes" : "No")
                            .multilineTextAlignment(.trailing)
                            .font(Font.system(size: 14, weight: .semibold))
                    }
                    .modifier(InputFieldViewModifier())
                }
                
                
            }
            
            Spacer()
            
            if isNew == true {
                Button(action: {
                    model.addDevice(deviceToEdit)
                }, label: {
                    Text("Done")
                })
                .buttonStyle(PlainLikeButtonStyle(.primary))
            } else {
                Button(action: {
                    model.deleteDevice(deviceToEdit)
                }, label: {
                    Text("Delete \(deviceToEdit.title)")
                })
                .buttonStyle(PlainLikeButtonStyle(.danger))
            }
        }
        .padding(.horizontal, Constants.UI.horizontalSectionSpacing)
        .padding(.vertical, Constants.UI.verticalSectionSpacing)
    }
}

struct EditingView_Previews: PreviewProvider {
    static var previews: some View {
        EditingView(deviceToEdit: nil)
            .environmentObject(ContentModel())
            .environmentObject(PartialSheetManager())
    }
}
