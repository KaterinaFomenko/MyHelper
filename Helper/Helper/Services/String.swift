//
//  String.swift
//  Helper
//
//  Created by Катерина Фоменко on 15/04/2025.
//

import Foundation
extension String {
    /// Возвращает локализованную версию текущей строки.
    var loc: String {
        return NSLocalizedString(self, comment: "")
    }
}
