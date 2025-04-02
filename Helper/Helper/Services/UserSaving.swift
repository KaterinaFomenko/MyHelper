//
//  UserSaving.swift
//  Helper
//
//  Created by Катерина Фоменко on 11/03/2025.
//

import Foundation

class UserSaving: ObservableObject {
    let KEY = "parentCardsArray"
    
    static var shared = UserSaving()

    func loadParentCardsArray() -> [CardModel] {
        guard let savedData = UserDefaults.standard.data(forKey: KEY) else {
            print("⚠️ No saved data found")
            return []
        }
        do {
            let decodedData = try JSONDecoder().decode([CardModel].self, from: savedData)
            print("🔄 Loaded \(decodedData.count) cards")
            return decodedData
        } catch {
            print("❌ Failed to load: \(error.localizedDescription)")
        }
        return []
    }
    
    func saveParentCardArray(_ array: [CardModel]) {
        if let encodeData = try? JSONEncoder().encode(array) {
            UserDefaults.standard.set(encodeData, forKey: KEY)
            print("💾 Saved parentCardsArray: \(array.count)")
        }
    }
    
    func removeCard(_ card: CardModel) {
        var cards = loadParentCardsArray()
        cards.removeAll { $0.cardId == card.cardId }
        saveParentCardArray(cards)
    }
}

