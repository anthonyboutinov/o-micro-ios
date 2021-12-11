//
//  CompleterResults.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony van den Brandt on 11.12.2021.
//

import SwiftUI
import MapKit

struct CompleterResults: View {
    
    @EnvironmentObject var map: MapTabModel
    
//    @Binding var selectedDestination: MKLocalSearchCompletion?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Constants.UI.itemSpacing) {
                ForEach(self.map.completerResults, id: \.self) { suggestion in
                    VStack(alignment: .leading, spacing: 0) {
                        Text(self.createHighlightedString(text: suggestion.title, rangeValues: suggestion.titleHighlightRanges))
                        Text(self.createHighlightedString(text: suggestion.subtitle, rangeValues: suggestion.subtitleHighlightRanges))
                            .dynamicTypeSize(SwiftUI.DynamicTypeSize.xSmall)
                            .foregroundColor(Color.gray)
                    }
//                        .onTapGesture {
//                            selectedDestination = suggestion
//                        }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
