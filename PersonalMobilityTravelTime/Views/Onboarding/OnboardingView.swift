//
//  OnboardingView.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 26.07.2021.
//

import SwiftUI
import ScrollViewIfNeeded

struct OnboardingView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        ScrollViewIfNeeded {
            VStack(alignment: .center) {
                Spacer()
                
                Image("Scooter3D")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.top, -180)
                    .padding(.bottom, -100)
                
                Text("Welcome to")
                    .font(.title3)
                    .foregroundColor(Color.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 5)
                    .padding(.top, Constants.UI.onboardingItemSpacing)
                
                Text("O-Micro")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 1)
                
                Text("A Micro-Mobility Travel Time Calculator")
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, Constants.UI.onboardingItemSpacing)
                
//                HStack(alignment: .center, spacing: 45, content: {
//                    DeviceIcon(named: "022-electricscooter")
//                    DeviceIcon(named: "026-one wheel")
//                    DeviceIcon(named: "028-bycicle")
//                })
//                    .padding(.bottom, Constants.UI.onboardingItemSpacing)
//                Spacer()
                
                Text("onboardingViewCallout")
                    .font(.callout)
                    .foregroundColor(Color.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, Constants.UI.onboardingItemSpacing)
                
                Spacer()
            }
            .frame(maxHeight: .infinity)
            
            Button(action: {
                model.setUpProcess = .noDevices
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
        OnboardingView().previewDevice("iPod touch (7th generation)").environmentObject(ContentModel.preview())
    }
}
