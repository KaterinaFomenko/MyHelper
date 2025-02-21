//
//  CardsJsonData.swift
//  Helper
//
//  Created by Катерина Фоменко on 21/02/2025.
//

import Foundation
import SwiftUI

struct CardModelJson: Decodable {
    
    var title: String
    var color: String
    var parentId: Int
    var imageName: String
    var cardId: Int
}

func load() -> [CardModelJson] {
    // 1. Поиск файла в Bundle
    guard let fileURL = Bundle.main.url(forResource: "Cards", withExtension: "json") else {
        print("File is not found")
        return []
    }
    
    let jsonData: Data
    do {
    // 2. Чтение данных из файла
        jsonData = try Data(contentsOf: fileURL)
        
    } catch {
        print("Couldn't load file from \(error.localizedDescription)")
        return []
    }
        
    do {
    // 3. Декодирование JSON в массив объектов
        let cardsData = try JSONDecoder().decode([CardModelJson].self, from: jsonData)
        print("CARDS DATA: \(cardsData)")
        return cardsData
        
    } catch {
        print("Decoding error the JSON from \(error.localizedDescription)")
        return []
    }
}
