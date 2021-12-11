//
//  BindingExtension.swift
//  PersonalMobilityTravelTime
//
//  Created by Khoa Pham
//  https://onmyway133.com/posts/how-to-do-didset-for-state-and-binding-in-swiftui/
//  How to do didSet for State and Binding in SwiftUI
//

import SwiftUI

extension Binding {
    func didSet(_ didSet: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                didSet(newValue)
            }
        )
    }
}
