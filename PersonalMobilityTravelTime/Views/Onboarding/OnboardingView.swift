//
//  OnboardingView.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 26.07.2021.
//

import SwiftUI

struct OnboardingView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        VStack {
            VStack(alignment: .center) {
                Spacer()
                
                Text("Welcome to")
                    .font(.title3)
                    .foregroundColor(Color.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 5)
                
                Text("Micro-Mobility Travel Time Calculator")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .lineLimit(10)
                
                HStack(alignment: .center, spacing: 45, content: {
                    DeviceIcon(named: "022-electricscooter")
                    DeviceIcon(named: "026-one wheel")
                    DeviceIcon(named: "028-bycicle")
                })
                Spacer()
                
                Text("onboardingViewCallout")
                    .font(.callout)
                    .foregroundColor(Color.secondary)
                
                Spacer()
            }
            .frame(maxHeight: .infinity)
            
            Button(action: {
                // TODO: needs more logic
                
//                if model.devices.count == 0 {
                    model.setUpProcess = .noDevices
//                } else {
//                    model.setUpProcess = .firstDeviceAddedSoComplete
//                }
            }, label: {
                Text("Let's Go!")
            })
            .buttonStyle(PlainLikeButtonStyle(.primary))
            .padding(.bottom, Constants.UI.onboardingButtonsBottomPadding)
        }
        .padding(.horizontal, Constants.UI.horizontalSectionSpacing)
        .padding(.vertical, Constants.UI.verticalSectionSpacing)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView().environmentObject(ContentModel.preview())
    }
}
