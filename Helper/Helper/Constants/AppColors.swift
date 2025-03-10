//
//  AppColors.swift
//  Helper
//
//  Created by Катерина Фоменко on 10/03/2025.
//

import Foundation
import SwiftUI

struct AppColors {
    
    static let arrayColorIds: [Int] = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
    
    static func getColor(groupId: Int) -> Color {
        switch groupId {
        case 1: return Color(hex: "F4D03F") // Приглушенный желтый
        case 2: return Color(hex: "E67E22") // Приглушенный оранжевый
        case 3: return Color(hex: "D2527F") // Приглушенный розовый
        case 4: return Color(hex: "FF9D23") // Яркий оранжевый
        case 5: return Color(hex: "71BBB2") // Яркий оливка
        case 6: return Color(hex: "D17D98") // Приглушенный фиолетовый
        case 7: return Color(hex: "E74C3C") // Приглушенный красный
        case 8: return Color(hex: "E73879") // Яркий розовый
        case 9: return Color(hex: "2980B9") // Приглушенный синий
        case 10: return Color(hex: "B1C29E") // Оливковый
        case 11: return Color(hex: "F39C12") // Приглушенный оранжевый
        case 12: return Color(hex: "D35400") // Теплый оранжевый
        case 13: return Color(hex: "27AE60") // Приглушенный зеленый
        case 14: return Color(hex: "5DADE2") // Приглушенный голубой
        case 15: return Color(hex: "EAEAEA") // Серый (по умолчанию)
        default: return Color.gray
        }
    }
}

//extension Color {
//    init(hex: String) {
//        let scanner = Scanner(string: hex)
//        var rgbValue: UInt64 = 0
//        scanner.scanHexInt64(&rgbValue)
//        
//        let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
//        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
//        let blue = Double(rgbValue & 0x0000FF) / 255.0
//        
//        self.init(red: red, green: green, blue: blue)
//    }
//}

extension Color {
    // Инициализатор для создания Color из HEX-строки
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0) // По умолчанию черный цвет
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

