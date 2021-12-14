//
//  FullscreenPromptView.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 26.07.2021.
//

import SwiftUI

struct FullscreenPromptView: View {
    
    var imageName: String?
    var iconName: String?
    var text: String
    var buttonLabel: String
    var buttonAction: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            if let iconName = iconName {
                Image(systemName: iconName)
                    .resizable()
                    .frame(width:75, height: 75, alignment: .center)
                    .foregroundColor(Color.secondary)
                    .padding(.bottom, 18)
                
            } else if let imageName = imageName {
                Image(imageName)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(Color.secondary)
                    .frame(width:75, height: 75, alignment: .center)
                    .padding(.bottom, 18)
            }
            
            Text(text)
                .font(.title2)
                .bold()
                .multilineTextAlignment(.center)
            
            Spacer()
            
            Button(action: buttonAction, label: {
                Text(buttonLabel)
            })
                .buttonStyle(PlainLikeButtonStyle(.primary))
                .padding(.bottom, Constants.UI.onboardingButtonsBottomPadding)
        }
        .padding(.horizontal, Constants.UI.horizontalSectionSpacing)
        .padding(.vertical, Constants.UI.verticalSectionSpacing)
    }
}

struct FullscreenPromptView_Previews: PreviewProvider {
    static var previews: some View {
        FullscreenPromptView(imageName: "022-electricscooter",text: "Let’s add your first\nmicro-mobility device.", buttonLabel: "Add Device", buttonAction: {})
    }
}
