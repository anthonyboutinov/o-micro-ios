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
                    .foregroundColor(Constants.Colors.graphite)
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
                
                Text("With this app you can get estimates on how long it will take you to travel by your electric scooter, one-wheel, bycicle or other micro-mobility device. We also estimate battery comsumption, if it’s an electric device.")
                    .font(.callout)
                    .foregroundColor(Constants.Colors.graphite)
                
                Spacer()
            }
            .frame(maxHeight: .infinity)
            
            Button(action: {
                // TODO: needs more logic
                
                if model.devices.count == 0 {
                    model.setUpProcess = .noDevices
                } else {
                    model.setUpProcess = .firstDeviceAddedSoComplete
                }
            }, label: {
                Text("Let's Go!")
            })
            .buttonStyle(PlainLikeButtonStyle(.primary))
        }
        .padding(.horizontal, Constants.UI.horizontalSectionSpacing)
        .padding(.vertical, Constants.UI.verticalSectionSpacing)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView().environmentObject(ContentModel())
    }
}
