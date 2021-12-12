//
//  CalculatorView.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 26.07.2021.
//

import SwiftUI

struct CalculatorView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.UI.sectionSpacing) {
            HStack {
                DeviceSelector()
                
                NavigationLink(Constants.Text.settingsLabel, destination: SettingsView())
                    .padding(.vertical, Constants.UI.verticalButtonSpacing)
            }
            
            if model.selectedDevice != nil {
                CalculatorViewBody()
                    .frame(maxHeight: .infinity)
            } else {
                Spacer()
            }
            
        }
        .padding(.horizontal, Constants.UI.horizontalSectionSpacing)
        .padding(.vertical, Constants.UI.verticalSectionSpacing)
        .navigationBarTitle("Calculator") //this must be empty or set to something
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView()
            .environmentObject(ContentModel())
    }
}
