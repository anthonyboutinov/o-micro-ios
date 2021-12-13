//
//  GeolocationDeniedView.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 28.07.2021.
//

import SwiftUI

struct GeolocationDeniedView: View {
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "location.slash.fill")
                .resizable()
                .frame(width:75, height: 75, alignment: .center)
                .foregroundColor(Constants.Colors.graphite)
                .padding(.bottom, 18)
            
            Text("Location tracking denied. Enable it in Settings to continue.")
                .font(.title2)
                .bold()
                .multilineTextAlignment(.center)
            
            Spacer()
            
            Button(action: {
                // open the app permission in Settings app
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            }, label: {
                Text("Open Settings")
            })
                .buttonStyle(PlainLikeButtonStyle(.primary))
        }
        .padding(.horizontal, Constants.UI.horizontalSectionSpacing)
        .padding(.vertical, Constants.UI.verticalSectionSpacing)
    }
}

struct GeolocationDeniedView_Previews: PreviewProvider {
    static var previews: some View {
        GeolocationDeniedView()
    }
}
