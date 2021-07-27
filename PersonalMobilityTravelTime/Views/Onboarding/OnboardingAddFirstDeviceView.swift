//
//  OnboardingAddFirstDeviceView.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 26.07.2021.
//

import SwiftUI

struct OnboardingAddFirstDeviceView: View {
    @EnvironmentObject var model: ContentModel
    var body: some View {
        FullscreenPromptView(imageName: "022-electricscooter", text: "Let’s add your first micro-mobility device.", buttonLabel: "Add Device") {
            model.setUpProcess = .addDevice
        }
//        VStack {
//            Spacer()
//            Image("022-electricscooter")
//                .resizable()
//                .frame(width:75, height: 75, alignment: .center)
//            Text("Let’s add your first micro-mobility device.")
//                .font(.title2)
//                .bold()
//            Spacer()
//            Button(action: {
//
//            }, label: {
//                Text("Add Device")
//            })
//            .buttonStyle(PlainLikeButtonStyle(.primary))
//        }
//        .padding(.horizontal, Constants.UI.horizontalSectionSpacing)
//        .padding(.vertical, Constants.UI.verticalSectionSpacing)
    }
}

struct OnboardingAddFirstDeviceView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingAddFirstDeviceView()
    }
}
