//
//  CompleterDelegate.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony van den Brandt on 11.12.2021.
//  Based on Apple's sample project "Searching for Nearby Points of Interest"
//

import Foundation
import MapKit

class SearchCompleterDelegate: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    
    @Published var completerResults: [MKLocalSearchCompletion] = [MKLocalSearchCompletion]() {
        didSet {
            print("CompleterDelegate.completerResults didSet to \(self.completerResults)")
        }
    }
    
    /// - Tag: QueryResults
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        print("completerDidUpdateResults with results: \(completer.results)")
        // As the user types, new completion suggestions are continuously returned to this method.
        // Overwrite the existing results, and then refresh the UI with the new results (@Published does that)
        completerResults = completer.results
    }
    
    /// Handles any errors returned from MKLocalSearchCompleter
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // Handle any errors returned from MKLocalSearchCompleter.
        if let error = error as NSError? {
            print("MKLocalSearchCompleter encountered an error: \(error.localizedDescription). The query fragment is: \"\(completer.queryFragment)\"")
        }
    }
}
