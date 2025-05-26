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
    
    static func getColor1(groupId: Int) -> Color {
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
    // "F8F8F8") // Почти белый — фон
    static func getColor(groupId: Int) -> Color {
        switch groupId {
        case 1: return Color(hex: "FFD54F") // Тёплый пастельный жёлтый — верх мегафона
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
        default: return Color.gray
        }
    }
    
    static func getColor2(groupId: Int) -> Color {
        switch groupId {
        case 1: return Color(hex: "FFECB3") // Мягкий солнечный (пастельный жёлтый)
        case 2: return Color(hex: "FFD180") // Персиковый (тёплый, приветливый)
        case 3: return Color(hex: "F8BBD0") // Светло-розовый (дружелюбие)
        case 4: return Color(hex: "B3E5FC") // Пастельный голубой (чистота, лёгкость)
        case 5: return Color(hex: "FFCDD2") // Тёплый розово-красный (эмоциональность)
        case 6: return Color(hex: "E1BEE7") // Пастельная лаванда (умиротворение)
            
        case 7: return Color(hex: "FFAB91") // Теплый коралловый (радость)
        case 8: return Color(hex: "81D4FA") // Яркий небесный голубой (надежда)
        case 9: return Color(hex: "90CAF9") // Светло-синий (доверие)
        case 10: return Color(hex: "C5E1A5") // Светло-оливковый (естественность)
        case 11: return Color(hex: "FFF59D") // Мягкий лимонный (энергия)
        case 12: return Color(hex: "FFB74D") // Тёплый мандариновый (активность)
        case 13: return Color(hex: "A5D6A7") // Мягкий зелёный (спокойствие)
        case 14: return Color(hex: "B2EBF2") // Ледяной голубой (освежающий)
        case 15: return Color(hex: "F5F5F5") // Очень светлый серый (нейтральный фон)
        default: return Color.gray
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


