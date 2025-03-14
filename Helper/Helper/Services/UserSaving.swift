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
    
    func saveParentCardArray2(_ array: [CardModel]) {
        let defaults = UserDefaults.standard
        defaults.set(array, forKey: KEY)
    }
    func loadParentCardsArray2() -> [CardModel] {
        let defaults = UserDefaults.standard
        let array = defaults.array(forKey: KEY) as? [CardModel]
        return array ?? []
    }

    func saveParentCardArray(_ array: [CardModel]) {
        if let encodeData = try? JSONEncoder().encode(array) {
            UserDefaults.standard.set(encodeData, forKey: "parentCardsArray")
            print("💾 Saved parentCardsArray: \(array.count)")
        }
    }
    
    func loadParentCardsArray() -> [CardModel] {
        guard let savedData = UserDefaults.standard.data(forKey: "parentCardsArray") else {
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
}



//    @Published var parentCardArray: [CardModel] = [] {
//        didSet {
//            saveParentCardArray()
//        }
//    }
//
//    init() {
//        loadParentCardsArray()
//    }
//    ----------
//    @Published var cardName: String = UserDefaults.standard.string(forKey: "cardName") ?? "" {
//        didSet {
//            UserDefaults.standard.set(cardName, forKey: "cardName")
//            print("🍄‍🟫 New Card Name: \(cardName)")
//        }
//    }
