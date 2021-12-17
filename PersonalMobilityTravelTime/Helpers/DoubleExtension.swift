//
//  NumberExtension.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 28.07.2021.
//

import Foundation

extension Double {
    func removeZerosFromEnd(leaveFirst maximumFractionDigits: Int = 16) -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = maximumFractionDigits //maximum digits in Double after dot (maximum precision)
        return String(formatter.string(from: number) ?? "")
    }
    
    func toMiles() -> Double {
        return self * 0.621371192
    }
    
    func toKilometers() -> Double {
        return self / 0.621371192
    }
    
    
    /// Converts to miles from kilometers if needed
    func inCurrentUnits(_ unit: Units) -> Double {
        switch unit {
        case .metric: return self;
        case .imperial: return self.toMiles()
        }
    }
    
    /// Converts to kilometers from miles if needed
    func inKilometers(_ unit: Units) -> Double {
        switch unit {
        case .metric: return self;
        case .imperial: return self.toKilometers()
        }
    }
    
    
}

extension NumberFormatter {
    static func byDefault(from input: String) -> NSNumber? {
        let numberFomatter: NumberFormatter = {
            let f = NumberFormatter()
            f.isLenient = true
            f.numberStyle = .none
            f.maximumFractionDigits = 1
            f.minimumFractionDigits = 0
            f.alwaysShowsDecimalSeparator = false
            return f
        }()
        return numberFomatter.number(from: input)
    }
}
