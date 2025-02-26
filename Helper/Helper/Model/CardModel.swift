//
//  CardsJsonData.swift
//  Helper
//
//  Created by Катерина Фоменко on 21/02/2025.
//

import Foundation
import SwiftUI
//cardsData.last?.childCards?[4].title ?? ""  ->  "Tooth"

struct CardModel: Decodable, Identifiable, Hashable {
    var id: Float { cardId }
    
    var cardId: Float
    var title: String
    var groupId: Int
    var imageName: String
    var priority: Int?
    var childCards: [CardModel]?
}

func load() -> [CardModel] {
    // 1. Поиск файла в Bundle
    guard let fileURL = Bundle.main.url(forResource: "Cards", withExtension: "json") else {
        print("❌ File is not found")
        return []
    }
    
    let jsonData: Data
    do {
    // 2. Чтение данных из файла
        jsonData = try Data(contentsOf: fileURL)
        print("✅ File is found: \(fileURL.path())")
    } catch {
        print("❌ Couldn't load file : \(error.localizedDescription)")
        return []
    }
        
    do {
    // 3. Декодирование JSON в массив объектов
        let cardsData = try JSONDecoder().decode([CardModel].self, from: jsonData)
        print("✅ CARDS DATA: \(cardsData)")
        return cardsData
        
    } catch {
        print("❌ Decoding error the JSON from \(error.localizedDescription)")
        return []
    }
}
