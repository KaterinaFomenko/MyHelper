//
//  Color_ext.swift
//  Helper
//
//  Created by Катерина Фоменко on 23/02/2025.
//

import Foundation
import SwiftUI

extension Color {
    func colorFromRGB(color: String) -> Color {
        let components = color.components(separatedBy: ",")
        guard components.count == 3,
              let red = Double(components[0]),
              let green = Double(components[1]),
              let blue = Double(components[2]) else {
            return .black
        }
        return Color(red: red / 255, green: green / 255, blue: blue / 255, opacity: 0.3)
    }
    
    
    
}
