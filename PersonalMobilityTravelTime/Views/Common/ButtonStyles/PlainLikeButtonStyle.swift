//
//  PlainButtonStyle.swift
//  PersonalMobilityTravelTime
//
//  Created by Anthony Boutinov on 26.07.2021.
//

import SwiftUI

//struct ListRowStyle: ViewModifier {
//    var style = Styles.white
//
//    private func foregroundColor() -> Color {
//        switch style {
//        case .primary:
//            return Constants.Colors.textInverse
//        case .destructive:
//            return Constants.Colors.red
//        case .cancel:
//            return Color.secondary
//        default:
//            return Color.accentColor
//        }
//    }
//
//    private func backgroundColor() -> Color {
//        switch style {
//        case .primary:
//            return Color.accentColor
//        default:
//            return Constants.Colors.transparent
//        }
//    }
//
//    func body(content: Content) -> some View {
//        content
//            .listRowBackground(backgroundColor())
//            .frame(maxWidth: .infinity)
//            .foregroundColor(foregroundColor())
//    }
//
//    init(_ style: Styles = Styles.white) {
//        self.style = style
//    }
//
//    enum Styles {
//        case white
//        case primary
//        case destructive
//        case cancel
//    }
//}

struct PlainLikeButtonStyle: ButtonStyle {
    var style = Styles.white

    private func foregroundColor() -> Color {
        switch style {
        case .primary:
            return Constants.Colors.textInverse
        case .destructive:
            return Constants.Colors.red
        case .cancel:
            return Color.secondary
        default:
            return Color.accentColor
        }
    }

    private func backgroundColor() -> Color {
        switch style {
        case .primary:
            return Color.accentColor
        default:
            return Constants.Colors.transparent
        }
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .listRowBackground(backgroundColor())
            .frame(maxWidth: .infinity)
            .foregroundColor(foregroundColor())
    }

    init(_ style: Styles = Styles.white) {
        self.style = style
    }

    enum Styles {
        case white
        case primary
        case destructive
        case cancel
    }
}
