//
//  CalculatorView.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 26.07.2021.
//

import SwiftUI

struct CalculatorView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Constants.UI.verticalSectionSpacing) {
                HStack {
                    DeviceSelector()
                    
                    Spacer()
                    
                    NavigationLink("Settings", destination: SettingsView())
                        .padding(.vertical, Constants.UI.verticalButtonSpacing)
                }
                
                
            }
            .padding(.horizontal, Constants.UI.horizontalSectionSpacing)
            .padding(.vertical, Constants.UI.verticalSectionSpacing)
        }
        .navigationBarHidden(true)
    }
}

struct CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView()
    }
}
