//
//  ContentModel.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 26.07.2021.
//

import Foundation

/// Primary view model of the app. Stores the general states of the app and list of user's devices
class ContentModel: ObservableObject {
    
    struct UserDefaultsKeys {
        static let setUpProcess = "setUpProcess"
        static let units = "units"
        static let devices = "devices"
        static let selectedDevice = "selectedDevice"
        static let selectedTabIndex = "selectedTabIndex"
    }
    
    // MARK: - Set Up Process
    /// Describes the global state of the app: if it should display a welcome screen or other onboarding screens, etc
    @Published var setUpProcess: SetUpProcess = {
        let defaultValue = SetUpProcess.firstLaunch
        if let rawValue = UserDefaults.standard.string(forKey: UserDefaultsKeys.setUpProcess) {
            if let value = SetUpProcess(rawValue: rawValue) {
                return value
            } else {
                return SetUpProcess.unknown
            }
        } else {
            return defaultValue
        }
    }() {
        didSet {
            UserDefaults.standard.set(self.setUpProcess.rawValue, forKey: UserDefaultsKeys.setUpProcess)
        }
    }
    
    /// Possible global states of the app: if it should display a welcome screen or other onboarding screens, etc
    enum SetUpProcess: String {
        case firstLaunch
        case noDevices
        case addFirstDevice
        case firstDeviceAddedSoComplete
        case unknown
    }
    
    // MARK: - General Properties
    
    /// User preference on which units of distance to use
    @Published var units: Units = {
        let defaultValue = Units.metric
        if let rawValue = UserDefaults.standard.string(forKey: UserDefaultsKeys.units) {
            if let value = Units(rawValue: rawValue) {
                return value
            }
        }
        return defaultValue
    }() {
        didSet {
            UserDefaults.standard.set(self.units.rawValue, forKey: UserDefaultsKeys.units)
        }
    }
    
    /// Stores all of the deivces that the user has
    @Published var devices: [MobilityDevice] = {
        var array = [MobilityDevice]()
        if let rawValues = UserDefaults.standard.array(forKey: UserDefaultsKeys.devices) as? [Data] {
            for rawValue in rawValues {
                if let value = try? MobilityDevice(from: rawValue) {
                    array.append(value)
                }
            }
        }
        return array
    }() {
        didSet {
            UserDefaults.standard.set(self.devices.map({d in
                d.encoded
            }), forKey: UserDefaultsKeys.devices)
        }
    }
    
    /// Tells the app which device is currently selected by the user
    @Published var selectedDevice: MobilityDevice? = {
        let defaultValue: MobilityDevice? = nil
        if let data = UserDefaults.standard.object(forKey: UserDefaultsKeys.selectedDevice) as? Data {
            if let value = try? MobilityDevice(from: data) {
                return value
            }
        }
        return defaultValue
    }() {
        didSet {
            print("didSet selectedDevice to \(self.selectedDevice?.title ?? "nil")")
            calculate()
            UserDefaults.standard.set(self.selectedDevice?.encoded, forKey: UserDefaultsKeys.selectedDevice)
        }
    }
    
    // TODO: this probably needs to be reworked. Though it works fine
    @Published var calculator: RouteStat?
    
    /// Which tab is currently selected: Map or Calculator
    @Published var currentTab: Tabs = Tabs(rawValue: UserDefaults.standard.integer(forKey: UserDefaultsKeys.selectedTabIndex))! {
        didSet {
            calculate()
            UserDefaults.standard.set(self.currentTab.rawValue, forKey: UserDefaultsKeys.selectedTabIndex)
        }
    }
    
    // MARK: - General Methods
    
    /// Default init
    init() {
        if selectedDevice == nil {
            selectedDevice = devices.first
        }
        
        if self.setUpProcess == .unknown {
            if self.devices.isEmpty {
                self.setUpProcess = .noDevices
            } else {
                self.setUpProcess = .firstDeviceAddedSoComplete
            }
        }
    }
    
    // TODO: ?? Not sure about that
    func calculate(distanceKm: Double?) {
        if currentTab == .calculator {
            if let distanceKm = distanceKm ?? calculator?.distanceKm {
                calculator = RouteStat(device: selectedDevice, distanceKm: distanceKm)
            }
        }
    }
    
    // TODO: ?? Not sure about that
    func calculate() {
        calculate(distanceKm: nil)
    }
    
    /// Adds the device to the list of all devices
    func addDevice(_ device: MobilityDevice) {
        guard device.isValid() else {
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
    
    /// Checks if the device is set up properly and replaces the old instance of it in the list of all devices with this new version
    func updateDevice(_ device: MobilityDevice) {
        guard device.isValid() else {
            return
        }
        if let index = self.devices.firstIndex(where: { d in
            d.id == device.id
        }) {
            self.devices[index] = device
        }
    }
    
    /// Deletes the device from the list of all devices
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
    
    /// Selects a device at a given index
    // Returnes Self so that it can be chained in texting (in previews)
    func selectDevice(atIndex index: Int) -> Self {
        self.selectedDevice = self.devices[index]
        return self
    }
    
    // MARK: - Testing
    
    /// Initializer for testing purposes (previews)
    init(setUpProcess: SetUpProcess, units: Units, devices: [MobilityDevice], selectedDeviceIndex: Int = 0) {
        self.setUpProcess = setUpProcess
        self.units = units
        self.devices = devices
        self.selectedDevice = devices[selectedDeviceIndex]
    }
    
    /// Creates an instance of ContentModel for testing (preview), filled in with sample data
    static func preview() -> ContentModel {
        return ContentModel(setUpProcess: .firstLaunch, units: .metric, devices: MobilityDevice.sampleDevices())
    }
    
    /// Sets units of measure to a given value, returns Self for the engeneer to be able to chain methods
    func setUnits(_ units: Units) -> Self {
        self.units = units
        return self
    }
    
    // MARK: - General Enums
    
    /// List of all the tabs in the app: Map, Calculator
    enum Tabs: Int {
        case map
        case calculator
    }
    
    /// Units of distance: Metric and Imperial
    enum Units: String, CustomStringConvertible, Identifiable {
        var id: Self { self }
        
        case metric
        case imperial
        
        static var all: [Units] {
            return [.metric, .imperial]
        }
        
        /// Returns short localized string description
        var description: String {
            switch self {
            case .metric: return String(localized: "km")
            case .imperial: return String(localized: "miles")
            }
        }
        
        /// Returns the localized name of the units
        var fullDescription: String {
            switch self {
            case .metric: return String(localized: "Kilometers")
            case .imperial: return String(localized: "Miles")
            }
        }
        
        /// Returns the localized string of \unit per hour
        var perHour: String {
            switch self {
            case .metric: return String(localized: "km/h")
            case .imperial: return String(localized: "mph")
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
        if let rangeKm = device?.rangeKm {
            return distanceKm / rangeKm
        }
        return nil
    }
}
