//
//  DirectionsMap.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 28.07.2021.
//

import SwiftUI
import MapKit

struct DirectionsMap: UIViewRepresentable {
    
    @EnvironmentObject var map: MapTabModel
    @EnvironmentObject var model: ContentModel
    
    var start: CLLocationCoordinate2D {
        return map.locationManager.location?.coordinate ?? CLLocationCoordinate2D()
    }
    
    var end: CLLocationCoordinate2D {
        if let lat = map.location?.coordinates?.latitude, let long = map.location?.coordinates?.longitude {
            return CLLocationCoordinate2D(latitude: lat, longitude: long)
        } else {
            return CLLocationCoordinate2D()
        }
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        // Show the user location
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        //Zoom to user location
        let noLocation = CLLocationCoordinate2D()
        let viewRegion = MKCoordinateRegion(center: noLocation, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.setRegion(viewRegion, animated: false)
        
        getRouteAndPlaceItOnTheMap(mapView)
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // By default we already have all the data we need, so we don't need to manipulate anything here
        
        // Remove annotations on Cancel event
        if (self.map.state == .initial) {
            Self.dismantleUIView(uiView, coordinator: ())
            print("updateUIView: mapView cleared")
        }
        
        if (self.map.displayingRouteForTransportType != self.model.selectedDevice?.transportType && self.map.state != .initial) {
            print("DisplayingRouteFor changed, changing route, clearing mapView")
            Self.dismantleUIView(uiView, coordinator: ())
            self.map.displayingRouteForTransportType = self.model.selectedDevice?.transportType
            getRouteAndPlaceItOnTheMap(uiView)
        }
        
    }
    
    func getRouteAndPlaceItOnTheMap(_ mapView: MKMapView) {
        if map.location != nil {
            
            // Create request for selected device
            let selectedDeviceTransportType = self.model.selectedDevice?.transportType.mapKit ?? .automobile
            let request = createDirectionsRequest(selectedDeviceTransportType)
            // Create directions object
            let directions = MKDirections(request: request)
            
            print("Directions for selected device (\(self.model.selectedDevice!.transportType)) created")
            
            // Calculate route
            directions.calculate { response, error in
                if error == nil && response != nil {
                    var totalDistance: Double = 0.0
                    // Plot the route on the map
                    for route in response!.routes {
                        mapView.addOverlay(route.polyline)
                        // Zoom into the region
                        mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: Constants.UI.mapEdgeInsetsVertical, left: Constants.UI.mapEdgeInsetsHorizontal, bottom: Constants.UI.mapEdgeInsetsVertical, right: Constants.UI.mapEdgeInsetsHorizontal), animated: false)
                        totalDistance += route.distance
                    }
                    
                    // convert meters to kilometers
                    totalDistance /= 1000
                    
                    self.map.routeDistances[self.model.selectedDevice!.transportType] = totalDistance
                    print("Route for selected device (\(self.model.selectedDevice!.transportType)) calculated: \(totalDistance)")
                }
            }
            
            // Place annotation for the end point
            let annotation = MKPointAnnotation()
            annotation.coordinate = end
            annotation.title = map.location?.name ?? ""
            mapView.addAnnotation(annotation)
            
            getOtherDistances(excluding: selectedDeviceTransportType)
        }
    }
    
    /// Create directions request for said transportType
    private func createDirectionsRequest(_ transportType: MKDirectionsTransportType) -> MKDirections.Request {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: start))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: end))
        request.transportType = transportType
        return request
    }
    
    /// Iterates through all other devices that have other transportType value and organize these thransportTypes into a dictionary with appropriate MKDirections
    private func createOtherTransportTypeRequests(excluding excludedTransportType: MKDirectionsTransportType) -> [MobilityDevice.TransportType: MKDirections] {
        var otherDirections = [MobilityDevice.TransportType: MKDirections]()
        for device in model.devices {
            let transportType = device.transportType.mapKit
            if device != model.selectedDevice && transportType != excludedTransportType {
                otherDirections[device.transportType] = MKDirections(request: createDirectionsRequest(transportType))
            }
        }
        return otherDirections
    }
    
    private func getOtherDistances(excluding excludedTransportType: MKDirectionsTransportType) {
        // For other devices only calculate distance based on their transportTypes
        let otherTransportTypeDirections = createOtherTransportTypeRequests(excluding: excludedTransportType)
        print("directions for other transport types created: \(otherTransportTypeDirections)")
        for (directionsType, directions) in otherTransportTypeDirections {
            directions.calculate { response, error in
                if error == nil && response != nil {
                    var totalDistance: Double = 0.0
                    for route in response!.routes {
                        totalDistance += route.distance
                    }
                    // convert meters to kilometers
                    totalDistance /= 1000
                    
                    self.map.routeDistances[directionsType] = totalDistance
                    print("route for \(directionsType) calculated: \(totalDistance)")
                }
            }
        }
    }
    
    static func dismantleUIView(_ uiView: MKMapView, coordinator: ()) {
        uiView.removeAnnotations(uiView.annotations)
        uiView.removeOverlays(uiView.overlays)
    }
    
    // MARK: - Coordinator
    
    func makeCoordinator() -> Self.Coordinator {
        return Coordinator()
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
            renderer.lineWidth = 5
            renderer.strokeColor = Constants.Colors.route
            return renderer
        }
    }
}
