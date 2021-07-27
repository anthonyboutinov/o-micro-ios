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
    @Published var setUpProcess = SetUpProcess.firstLaunch
        
    enum SetUpProcess {
        case firstLaunch
        case noDevices
        case addDevice
        case complete
    }
    
    // MARK: - General
    
    @Published var units = Units.metric
    
    @Published var devices = [MobilityDevice]()
    @Published var selectedDevice: MobilityDevice? {
        didSet {
            calculate()
        }
    }
    
    //    @Published var calculatorTab: CalculatorTabModel
    @Published var calculator: RouteStat?
    @Published var map: MapTabModel
    
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
    
    init() {
        
        //        calculatorTab = CalculatorTabModel()
        map = MapTabModel()
        currentTab = Tabs.calculator
        
        populateDevices()
    }
    
    func populateDevices() {
        devices.append(MobilityDevice(id: UUID(), index: 0, title: "Ninebot ES1", iconName: "022-electricscooter", isElectric: true, averageSpeedKmh: 10.8, distanceOnFullChargeKm: 14.5, whereCanBeRidden: [Constants.WhereCanBeRidden.pedestrianPaths]))
        devices.append(MobilityDevice(id: UUID(), index: 0, title: "My Bike", iconName: "030-bike", isElectric: false, averageSpeedKmh: 17.3, distanceOnFullChargeKm: nil, whereCanBeRidden: [Constants.WhereCanBeRidden.carRoads, Constants.WhereCanBeRidden.pedestrianPaths]))
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
    
    func addDevice(_ device: MobilityDevice) {
        if devices.count > 0 {
            device.index = devices.last!.index + 1
        } else {
            device.index = 0
        }
        devices.append(device)
//        devices.sort { a, b in
//            a.index < b.index
//        }
    }
    
    func updateDevice(_ device: MobilityDevice) {
        if selectedDevice?.id == device.id {
            selectedDevice = device
        }
    }
    
    func deleteDevice(_ device: MobilityDevice) {
        // TODO: delete device
        
        if let index = devices.lastIndex(where: { d in
            d.id == device.id
        }) {
            devices.remove(at: index)
        }
    }
    
    enum Tabs {
        case calculator
        case map
    }
    
    enum Units {
        case metric
        case imperial
    }
}
