//
//  ChooseIconView.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 27.07.2021.
//

import SwiftUI

struct ChooseIconView: View {
    
    @Binding var selectedIcon: String
    @Binding var changeApproved: Bool
    @Binding var isSheetShown: Bool
        
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Choose Icon")
                .modifierSheetTitle()
            
            let minWidth = Constants.UI.deviceIconSize * DeviceIcon.scaleFactor(.large)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: minWidth, maximum: minWidth * 2))], spacing: 10) {
                
                ForEach(Constants.allIcons, id: \.self) { icon in
                    Button(action: {
                        selectedIcon = icon
                    }, label: {
                        DeviceIcon(named: icon, scale: .large)
                            .foregroundColor(icon == selectedIcon ? .accentColor : .black)
                    })
                    
                }
            }
            
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
    }
}

struct ChooseIconView_Previews: PreviewProvider {
    @State static var s = "021-motorbike"
    @State static var a = true
    @State static var shown = true
    static var previews: some View {
        ChooseIconView(selectedIcon: $s, changeApproved: $a, isSheetShown: $shown)
            .previewLayout(.sizeThatFits)
    }
}
