//
//  LaunchView.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 26.07.2021.
//

import SwiftUI

struct LaunchView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        if model.setUpProcess == .firstLaunch {
            OnboardingView()
        } else if model.setUpProcess == .noDevices {
            OnboardingAddFirstDeviceView()
        } else if model.setUpProcess == .addFirstDevice {
            EditingView(deviceToEdit: nil)
                .addPartialSheet()
        } else if model.setUpProcess == .firstDeviceAddedSoComplete {
            NavigationView() {
                TabView(selection: $model.selectedTabIndex) {
                    CalculatorView().tabItem {
                        Image(systemName: "slider.horizontal.below.rectangle")
                        Text("Calculator")
                    }.tag(0)
                    MapView().tabItem {
                        Image(systemName: "map.fill")
                        Text("Map")
                    }.tag(1)
                }
                .addPartialSheet()
            }
        }
    }
}

//struct LaunchView_Previews: PreviewProvider {
//    static var previews: some View {
//        LaunchView()
//    }
//}
