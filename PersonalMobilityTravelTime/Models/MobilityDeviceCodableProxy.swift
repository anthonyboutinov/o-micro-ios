//
//  MobilityDeviceCodable.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony van den Brandt on 15.12.2021.
//

import Foundation
import MapKit

/// A Codable version of MobilityDevice. Because it would be too much work to make the MobilityDevice class conform to Codable protocol itself
struct MobilityDeviceCodableProxy: Codable {
    
    enum InitError: Error {
        case unableToDecodeAndInitFromData
    }
    
    var id: UUID = UUID()
    var title: String
    var iconName: String
    var isElectric: Bool
    var averageSpeedCalculatorData: MobilityDevice.AverageSpeedCalculatorData?
    var averageSpeedKmh: Double
    var rangeKm: Double?
    var transportType: MobilityDevice.TransportType
    
    /// Decodes into an instance of MobilityDeviceCodableProxy from given data using JSONDecoder
    static func decode(from data: Data) throws -> Self {
        let decoder = JSONDecoder()
        if let object = try? decoder.decode(MobilityDeviceCodableProxy.self, from: data) {
            return object
        }
        throw InitError.unableToDecodeAndInitFromData
    }
}
