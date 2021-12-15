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
        FullscreenPromptView(imageName: "022-electricscooter", text: LocalizedStringKey("Let’s add your first micro-mobility device"), buttonLabel: LocalizedStringKey("Add Device")) {
            model.setUpProcess = .addFirstDevice
        }
    }
}

struct OnboardingAddFirstDeviceView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingAddFirstDeviceView()
    }
}
