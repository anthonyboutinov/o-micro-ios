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
    
    var location: Location?
    
    var start: CLLocationCoordinate2D {
        return map.locationManager.location?.coordinate ?? CLLocationCoordinate2D()
    }
    
    var end: CLLocationCoordinate2D {
        if let lat = location?.coordinates?.latitude, let long = location?.coordinates?.longitude {
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
        mapView.userTrackingMode = .followWithHeading
        
        getRouteAndPlaceItOnTheMap(mapView)
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // We already have all the data we need, so we don't need to manipulate anything here
    }
    
    func getRouteAndPlaceItOnTheMap(_ mapView: MKMapView) {
        if location != nil {
            
            // Create directions request
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: start))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: end))
            
            // Create directions object
            let directions = MKDirections(request: request)
            
            // Calculate route
            directions.calculate { response, error in
                if error == nil && response != nil {
                    // Plot the route on the map
                    for route in response!.routes {
                        mapView.addOverlay(route.polyline)
                        // Zoom into the region
                        mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50), animated: true)
                    }
                    
                }
            }
            
            // Place annotation for the end point
            let annotation = MKPointAnnotation()
            annotation.coordinate = end
            annotation.title = location?.name ?? ""
            mapView.addAnnotation(annotation)
            
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
            renderer.strokeColor = .blue
            return renderer
        }
    }
}
