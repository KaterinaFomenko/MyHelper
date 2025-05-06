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

