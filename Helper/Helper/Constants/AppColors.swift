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
    
    // "F8F8F8") // Почти белый — фон
    static func getColor(groupId: Int) -> Color {
        switch groupId {
        case 1: return Color(hex: "FEA4A1") // Тёплый пастельный жёлтый — верх мегафона
        case 2: return Color(hex: "4FC3F7") // Светло-голубой — корпус мегафона
        case 3: return Color(hex: "E57373") // Мягкий красный — основные сердечки
        case 4: return Color(hex: "AED581") // Мягкий зелёный — ручка мегафона
        case 5: return Color(hex: "FDC455") // Апельсин
        case 6: return Color(hex: "D0ACF8") // Лаванда
        case 7: return Color(hex: "FFB6B6") // Светло-красный — градиент сердечек
        case 8: return Color(hex: "EF9A9A") // Светло-розовый — объём сердечек
        case 9: return Color(hex: "FF8A80") // Яркий розово-красный — разнообразие сердечек
        case 10: return Color(hex: "FFECB3") // Тёплый кремовый — для карточек
        case 11: return Color(hex: "81D4FA") // Нежно-голубой — акценты
        case 12: return Color(hex: "C5E1A5") // Светло-зелёный — фон карточек
        case 13: return Color(hex: "FFCCBC") // Мягкий коралловый — кнопки
        case 14: return Color(hex: "B2EBF2") // Мятный — разделители
        case 15: return Color(hex: "F48FB1") // Нежно-розовый — выделение
        case 16: return Color(hex: "CE93D8") // Лёгкий фиолетовый — меню
        case 17: return Color(hex: "FFF59D") // Лимонный — иконки
        case 18: return Color(hex: "A5D6A7") // Оливково-зелёный — рамки
        case 19: return Color(hex: "90CAF9") // Яркий голубой — анимации
        case 20: return Color(hex: "EAEAEA") // Серый (по умолчанию)
        default: return Color(hex: "E4E5E6")
        }
    }
    
    static func getColorCircle(cardId: Int) -> Int {
        //Расчет colorId по кругу
        var colorId = cardId % arrayColorIds.count
        return colorId
        
    }
    
    static func color(for cardId: Int) -> Color {
        let ind = getColorCircle(cardId: cardId)
        let groupInd = arrayColorIds[ind] + 1
        return getColor(groupId: groupInd)
    }
    
    static func linearGradient() -> LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: "D0ECF9"), // Небесно-голубой (низ)
                Color(hex: "F2F8FC")  // Светло-голубой (верх)
            ]),
            startPoint: .bottom,
            endPoint: .top
        )
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}


