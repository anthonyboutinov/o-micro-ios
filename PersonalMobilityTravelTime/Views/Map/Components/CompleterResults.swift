//
//  CompleterResults.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony van den Brandt on 11.12.2021.
//

import SwiftUI
import MapKit
//import ScrollViewIfNeeded

struct CompleterResults: View {
    
    @EnvironmentObject var map: MapTabModel
    
    var body: some View {
        if let suggestions = self.map.completerResults {
            List {
                ForEach(suggestions, id: \.self) { suggestion in
                    Button {
                        map.search(for: suggestion)
                        if map.originLabel == "" {
                            map.originLabel = "Current Location"
                            // TODO: more needs to be done here, or this might need to be moved to the view model
                        }
                        map.state = .sentSearchRequest
                        UIApplication.shared.endEditing()
                    } label: {
                        VStack(alignment: .leading, spacing: 0) {
                            Text(self.createHighlightedString(text: suggestion.title, rangeValues: suggestion.titleHighlightRanges))
                                .foregroundColor(.primary)
                            if suggestion.subtitle != "" {
                                Text(self.createHighlightedString(text: suggestion.subtitle, rangeValues: suggestion.subtitleHighlightRanges))
                                    .dynamicTypeSize(SwiftUI.DynamicTypeSize.xSmall)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
        }
    }
    
    private func createHighlightedString(text: String, rangeValues: [NSValue]) -> NSAttributedString {
        let attributes = [NSAttributedString.Key.backgroundColor: UIColor.systemYellow ]
        let highlightedString = NSMutableAttributedString(string: text)
        
        // Each `NSValue` wraps an `NSRange` that can be used as a style attribute's range with `NSAttributedString`.
        let ranges = rangeValues.map { $0.rangeValue }
        ranges.forEach { (range) in
            highlightedString.addAttributes(attributes, range: range)
        }
        
        return highlightedString
    }
}
