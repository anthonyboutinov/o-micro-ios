//
//  TextExtension.swift
//  PersonalMobilityTravelTime
//

import SwiftUI

extension Text {
    init(_ astring: NSAttributedString) {
        self.init("")
        
        astring.enumerateAttributes(in: NSRange(location: 0, length: astring.length), options: []) { (attrs, range, _) in
            
            var t = Text(astring.attributedSubstring(from: range).string)
            
//            if let color = attrs[NSAttributedString.Key.foregroundColor] as? UIColor {
//                t  = t.foregroundColor(Color(color))
//            }
            
            if let _ = attrs[NSAttributedString.Key.backgroundColor] {
                t = t.fontWeight(.semibold)
            }
     
            self = self + t
            
        }
    }
}
