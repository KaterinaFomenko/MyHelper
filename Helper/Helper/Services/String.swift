//
//  String.swift
//  Helper
//
//  Created by Катерина Фоменко on 15/04/2025.
//

import Foundation
import SwiftUI

extension String {
    /// Возвращает локализованную версию текущей строки.
    var loc: String {
        return NSLocalizedString(self, comment: "")
    }
    var lkey: LocalizedStringKey {
        return LocalizedStringKey(self)
    }
    
    func getLocalizedString(language: String = "en", // Язык по умолчанию - польский
                            table: String = "Localizable") -> String {
        let key = self
        
        // 1. Находим путь к нужному lproj
        guard let path = Bundle.main.path(forResource: language, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            print("⚠️ Бандл для языка \(language) не найден, используется fallback")
            return NSLocalizedString(key,
                                     tableName: table,
                                     value: key, // Fallback - вернёт ключ, если перевод отсутствует
                                     comment: "")
        }
        
        // 2. Получаем строку из конкретной таблицы
        let localizedString = NSLocalizedString(key,
                                                tableName: table,
                                                bundle: bundle,
                                                value: "", // Пустая строка как fallback
                                                comment: "")
        
        // 3. Если перевод не найден, возвращаем ключ
        return localizedString.isEmpty ? key : localizedString
    }
}


extension LocalizedStringKey {
    func toString() -> String {
        let mirror = Mirror(reflecting: self)
        guard let key = mirror.children.first(where: { $0.label == "key" })?.value as? String else {
            return ""
        }
        return NSLocalizedString(key, comment: "")
    }
}


//extension Locale {
//    func identifierWithRegion() -> String {
//        let language = self.languageCode ?? "en"
//        let region = self.regionCode ?? Locale.current.regionCode ?? "US"
//        return "\(language)-\(region)"
//    }
//}

