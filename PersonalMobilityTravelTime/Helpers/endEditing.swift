//
//  endEditing.swift
//  PersonalMobilityTravelTime
//
//  Code taken from: https://stackoverflow.com/questions/56491386/how-to-hide-keyboard-when-using-swiftui#56496669
//
//  How to call this function:
//  UIApplication.shared.endEditing()
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
