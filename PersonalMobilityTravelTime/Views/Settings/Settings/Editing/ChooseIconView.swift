//
//  ChooseIconView.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 27.07.2021.
//

import SwiftUI

struct ChooseIconView: View {
    
    @Binding var selectedIcon: String
        
    var body: some View {
        List {
            let minWidth = Constants.UI.deviceIconSize * DeviceIcon.scaleFactor(.large)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: minWidth, maximum: minWidth * 2))], spacing: 10) {
                
                ForEach(Constants.allIcons, id: \.self) { icon in
                    Button(action: {
                        selectedIcon = icon
                    }, label: {
                        DeviceIcon(named: icon, scale: .large)
                            .foregroundColor(icon == selectedIcon ? .accentColor : Color.primary)
                    })
                }
            }
        }
        .navigationTitle("Icon")
    }
}

struct ChooseIconView_Previews: PreviewProvider {
    @State static var s = "021-motorbike"
    static var previews: some View {
        ChooseIconView(selectedIcon: $s)
            .previewLayout(.sizeThatFits)
    }
}
