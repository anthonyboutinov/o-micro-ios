//
//  LaunchView.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 26.07.2021.
//

import SwiftUI

struct LaunchView: View {
    
    @EnvironmentObject var model: ContentModel
    
    let mapTabModel = MapTabModel()
    
    var body: some View {
        if model.setUpProcess == .firstLaunch {
            OnboardingView()
        } else if model.setUpProcess == .noDevices {
            OnboardingAddFirstDeviceView()
        } else if model.setUpProcess == .addFirstDevice {
            NavigationView() {
                EditingView(deviceToEdit: nil)
            }
        } else if model.setUpProcess == .firstDeviceAddedSoComplete {
            NavigationView() {
                TabView(selection: $model.selectedTabIndex) {
                    CalculatorView().tabItem {
                        Image(systemName: "slider.horizontal.below.rectangle")
                        Text("Calculator")
                    }.tag(0)
                        .navigationBarTitle("Calculator") //this must be empty or set to something
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true)
                    MapView().tabItem {
                        Image(systemName: "map.fill")
                        Text("Map")
                    }.tag(1)
                        .environmentObject(mapTabModel)
                        .navigationBarTitle("Map") //this must be empty or set to something
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true)
                }
            }
        }
    }
}
