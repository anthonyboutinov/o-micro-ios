//
//  MobilityDevice.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 26.07.2021.
//

import Foundation
import MapKit

/// Describes a mobility device
final class MobilityDevice: Identifiable, ObservableObject, Hashable {
    
    var id: UUID = UUID()
    
    @Published var title: String = ""
    @Published var iconName: String = ""
    @Published var isElectric: Bool = false
    @Published var averageSpeedCalculatorData: AverageSpeedCalculatorData?
    @Published var averageSpeedKmh: Double = 14
    @Published var rangeKm: Double?
    @Published var transportType: TransportType = .pedestrian
        
    /// Init for setting up a new device
    init() {}
    
    /// Initialize from a MobilityDeviceCodableProxy
    private convenience init(from p: MobilityDeviceCodableProxy) {
        self.init(id: p.id, title: p.title, iconName: p.iconName, isElectric: p.isElectric, averageSpeedKmh: p.averageSpeedKmh, rangeKm: p.rangeKm, transportType: p.transportType)
    }
    
    /// Initialize from data
    convenience init(from data: Data) throws {
        self.init(from: try MobilityDeviceCodableProxy.decode(from: data))
    }
    
    /// Initialize from values
    init(id: UUID = UUID(), title: String, iconName: String, isElectric: Bool, averageSpeedKmh: Double, rangeKm: Double?, transportType: TransportType) {
        self.id = id
        self.title = title
        self.iconName = iconName
        self.isElectric = isElectric
        self.averageSpeedKmh = averageSpeedKmh
        self.rangeKm = rangeKm
        self.transportType = transportType
    }
    
    /// Returns true if this device instance is set up properly to be added to user's list of devices
    func isValid() -> Bool {
        return iconName != "" && title != "" && averageSpeedKmh > 0 && (isElectric ? rangeKm != nil && rangeKm! > 0 : true)
    }
    
    /// Returns a single sample device for testing (previews)
    static func sample() -> MobilityDevice {
        return MobilityDevice(title: "Ninebot ES1", iconName: "022-electricscooter", isElectric: true, averageSpeedKmh: 10.8, rangeKm: 14.5, transportType: .pedestrian)
    }
    
    /// Returns a list of sample devices for testing (previews)
    static func sampleDevices() -> [MobilityDevice] {
        var devices = [MobilityDevice]()
        devices.append(Self.sample())
        devices.append(MobilityDevice(title: "My Bike", iconName: "030-bike", isElectric: false, averageSpeedKmh: 17.34, rangeKm: nil, transportType: .automobile))
        devices.append(MobilityDevice(title: "Jetpack", iconName: "031-jetpack", isElectric: false, averageSpeedKmh: 50, rangeKm: nil, transportType: .pedestrian))
        return devices
    }
    
    /// Stores data for the Average Speed Calculator popup in the device's settings screen
    struct AverageSpeedCalculatorData: Codable {
        var distanceKm: Double
        var travelTimeMinutes: Double
    }
    
    /// JSON encoded data reprsentation
    var encoded: Data? {
        let proxy = MobilityDeviceCodableProxy(id: self.id, title: self.title, iconName: self.iconName, isElectric: self.isElectric, averageSpeedCalculatorData: self.averageSpeedCalculatorData, averageSpeedKmh: self.averageSpeedKmh, rangeKm: self.rangeKm, transportType: self.transportType)
        let encoder = JSONEncoder()
        return try? encoder.encode(proxy)
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
    final class Calculator {
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
    
    enum TransportType: String, CustomStringConvertible, Identifiable, Codable {
        case pedestrian = "pedestrian"
        case automobile = "automobile"
        
        /// Representation in MKDirectionsTransportType
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
