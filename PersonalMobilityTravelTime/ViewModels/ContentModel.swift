//
//  ContentModel.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 26.07.2021.
//

import Foundation

class ContentModel: ObservableObject {
    
    // MARK: - First Launch
//
//    @Published var isFirstLaunch: Bool {
//        didSet {
//            if oldValue == true {
//                isSettingUpProcessActive = true
//            }
//        }
//    }
    @Published var setUpProcess = SetUpProcess.firstDeviceAddedSoComplete // SetUpProcess.firstLaunch
        
    enum SetUpProcess {
        case firstLaunch
        case noDevices
        case addFirstDevice
        case firstDeviceAddedSoComplete
    }
    
    // MARK: - General Properties
    
    @Published var units = Units.metric
    
    @Published var devices = [MobilityDevice]()
    @Published var selectedDevice: MobilityDevice? {
        didSet {
            calculate()
        }
    }
    
    //    @Published var calculatorTab: CalculatorTabModel
    @Published var calculator: RouteStat?
//    @Published var map: MapTabModel
    
    @Published var currentTab: Tabs {
        didSet {
            calculate()
        }
    }
    @Published var selectedTabIndex = 0 {
        didSet {
            currentTab = selectedTabIndex == 0 ? .calculator : .map
        }
    }
    
    // MARK: - General Methods
    
    init() {
        
        //        calculatorTab = CalculatorTabModel()
//        map = MapTabModel()
        currentTab = Tabs.calculator
        
        populateDevices()
        selectedDevice = devices.first
    }
    
    func calculate(distanceKm: Double?) {
        if currentTab == .calculator {
            if let distanceKm = distanceKm ?? calculator?.distanceKm {
                calculator = RouteStat(device: selectedDevice, distanceKm: distanceKm)
            }
        }
    }
    
    func calculate() {
        calculate(distanceKm: nil)
    }
    
    static func isValid(_ device: MobilityDevice) -> Bool {
        return device.iconName != "" && device.title != "" && device.averageSpeedKmh > 0
    }
    
    func addDevice(_ device: MobilityDevice) {
        guard Self.isValid(device) else {
            return
        }
        if devices.count > 0 {
            device.index = devices.last!.index + 1
        } else {
            device.index = 0
        }
        devices.append(device)
        
        self.selectedDevice = device
        
        if self.setUpProcess == .addFirstDevice {
            self.setUpProcess = .firstDeviceAddedSoComplete
        }
    }
    
    func updateDevice(_ device: MobilityDevice) {
        guard Self.isValid(device) else {
            return
        }
        if let index = self.devices.firstIndex(where: { d in
            d.id == device.id
        }) {
            self.devices[index] = device
        }
    }
    
    func deleteDevice(_ device: MobilityDevice) {
        if let index = devices.lastIndex(where: { d in
            d.id == device.id
        }) {
            devices.remove(at: index)
        }
        
        if self.devices.count == 0 {
            self.setUpProcess = .noDevices
        }
    }
    
    // MARK: - Testing
    
    static let PreviewInImperialUnits: ContentModel = {
        let a = ContentModel()
        a.units = .imperial
        return a
    }()
    
    func sampleData() -> ContentModel {
        self.populateDevices()
        return self
    }
    
    func populateDevices() {
        devices.append(MobilityDevice(id: UUID(), index: 0, title: "Ninebot ES1", iconName: "022-electricscooter", isElectric: true, averageSpeedKmh: 10.22, distanceOnFullChargeKm: 14.5, transportType: .pedestrian))
        devices.append(MobilityDevice(id: UUID(), index: 1, title: "My Bike", iconName: "030-bike", isElectric: false, averageSpeedKmh: 17.34, distanceOnFullChargeKm: nil, transportType: .automobile))
        devices.append(MobilityDevice(id: UUID(), index: 1, title: "Jetpack", iconName: "031-jetpack", isElectric: false, averageSpeedKmh: 50, distanceOnFullChargeKm: nil, transportType: .pedestrian))
    }
    
    func selectDevice(atIndex index: Int) -> Self {
        self.selectedDevice = self.devices[index]
        return self
    }
    
    // MARK: - General Enums
    
    enum Tabs {
        case calculator
        case map
    }
    
    enum Units: CustomStringConvertible {
        case metric
        case imperial
        
        var description: String {
            switch self {
            case .metric: return "km"
            case .imperial: return "miles"
            }
        }
        
        var fullDescription: String {
            switch self {
            case .metric: return "Kilometers"
            case .imperial: return "Miles"
            }
        }
        
        var perHour: String {
            switch self {
            case .metric: return "km/h"
            case .imperial: return "mph"
            }
        }
    }
}


// MARK: - RouteStat
struct RouteStat {
    weak var device: MobilityDevice?

    var distanceKm: Double

    var timeH: Double? {
        if let device = device {
            return distanceKm / device.averageSpeedKmh
        }
        return nil
    }
    var batteryPercentage: Double? {
        if let distanceOnFullChargeKm = device?.distanceOnFullChargeKm {
            return distanceKm / distanceOnFullChargeKm
        }
        return nil
    }
}
