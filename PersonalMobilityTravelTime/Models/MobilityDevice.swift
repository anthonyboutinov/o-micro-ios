//
//  MobilityDevice.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 26.07.2021.
//

import Foundation
import MapKit

class MobilityDevice: Identifiable, ObservableObject, Hashable {
    
    var id: UUID = UUID()
    @Published var index: Int = 0
    
    @Published var title: String = ""
    @Published var iconName: String = ""
    @Published var isElectric: Bool = false
    @Published var averageSpeedCalculatorData: AverageSpeedCalculatorData?
    @Published var averageSpeedKmh: Double = 14
    @Published var rangeKm: Double?
    @Published var transportType: TransportType = .automobile
    
    static let suggestedDefaultRangeKm: Double = 10.0
    
    init(index: Int?) {
        self.index = index ?? 0
    }
    
    init(id: UUID, index: Int, title: String, iconName: String, isElectric: Bool, averageSpeedKmh: Double, rangeKm: Double?, transportType: TransportType) {
        self.id = id
        self.index = index
        self.title = title
        self.iconName = iconName
        self.isElectric = isElectric
        self.averageSpeedKmh = averageSpeedKmh
        self.rangeKm = rangeKm
        self.transportType = transportType
    }
    
    func isValid() -> Bool {
        return iconName != "" && title != "" && averageSpeedKmh > 0 && (isElectric ? rangeKm != nil && rangeKm! > 0 : true)
    }
    
    static func sample() -> MobilityDevice {
        return MobilityDevice(id: UUID(), index: 0, title: "Ninebot ES1", iconName: "022-electricscooter", isElectric: true, averageSpeedKmh: 10.8, rangeKm: 14.5, transportType: .pedestrian)
    }
    
    /// Stores data for the Average Speed Calculator popup in the device's settings screen
    struct AverageSpeedCalculatorData {
        var distanceKm: Double
        var travelTimeMinutes: Double
    }
    
    // MARK: - Conforming to Hashable
    
    static func == (lhs: MobilityDevice, rhs: MobilityDevice) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        self.id.hash(into: &hasher)
    }
    
    var hashValue: Int {
        self.id.hashValue
    }
    
    // MARK: - Calculator subclass
    class Calculator {
        private static func timeToTravel(_ distance: Double, averageSpeedKmh: Double) -> Double {
            return distance / averageSpeedKmh * 60.0
        }
        
        /// # Travel Time
        /// Returns time it would take to travel given distance. Formats the result to make it as short as possible, while remaining uniform in length as much as possible: "31 min", "2 h", "1:40"
        static func travelTimeFormattedCompactly(distance: Double, averageSpeedKmh: Double, superCompact: Bool = false) -> String {
            let timeToTravel = timeToTravel(distance, averageSpeedKmh: averageSpeedKmh)
            let rounded = timeToTravel.rounded()
            if timeToTravel >= 60 {
                let fullHours = floor(rounded / 60)
                let leftoverMinutes = Int(rounded.truncatingRemainder(dividingBy: 60.0))
                if leftoverMinutes < 3 { // if is full hours ±3 min
                    return String(format: "%.0f \(String(localized: "h"))", fullHours)
                } else if (superCompact) {
                    return String(format: "%.0f:%02d", fullHours, leftoverMinutes)
                } else {
                    return String(format: "%.0f \(String(localized: "h")) %.0f \(String(localized: "min"))", fullHours, leftoverMinutes)
                }
            } else {
                return String(format: "%.0f \(String(localized: "min"))", timeToTravel)
            }
        }
        
        /// # Battery usage
        /// Returns the amount of battery charge that would be used for given distance and device battery capacity, value in percentage. Can be more than 1.0
        static func batteryUsage(distance: Double, capacity: Double) -> Double {
            return distance / capacity
        }
    }
    
//    func batteryUsagePercentage(distance: Double) -> Double? {
//        if let capacity = self.rangeKm {
//            return distance / capacity
//        } else {
//            return nil
//        }
//    }
    
    enum TransportType: CustomStringConvertible, Identifiable {
        case pedestrian
        case automobile
        
        /// Converts to MKDirectionsTransportType
        var mapKit: MKDirectionsTransportType {
            get {
                switch self {
                case .pedestrian: return MKDirectionsTransportType.walking
                case .automobile: return MKDirectionsTransportType.automobile
                }
            }
        }
        
        var description: String {
            switch self {
            case .pedestrian: return String(localized: "Sidewalks")
            case .automobile: return String(localized: "Roads")
            }
        }
        
        static var all: [Self] {
            return [.pedestrian, .automobile]
        }
        
        var id: Self { self }
    }
    
}
