//
//  DeviceIcon.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 26.07.2021.
//

import SwiftUI

struct DeviceIcon: View {
    var named: String
    var scale: Scale = .medium
    
    static func scaleFactor(_ scale: Scale) -> CGFloat {
        switch scale {
        case .small:
            return 0.8
        case .large:
            return 1.4285714286 * 0.9
        default:
            return 1.0
        }
    }
    
    private var scaleFactor: CGFloat {
        return DeviceIcon.scaleFactor(scale)
    }
    
    var body: some View {
        Image(named)
            .renderingMode(.template)
            .resizable()
            .frame(width: Constants.UI.deviceIconSize * scaleFactor, height: Constants.UI.deviceIconSize * scaleFactor, alignment: .center)
        
    }
    
    enum Scale {
        case small
        case medium
        case large
    }
}
